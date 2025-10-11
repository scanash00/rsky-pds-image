# ------------------------------
# Stage 1: Builder
# ------------------------------
FROM rust:latest AS builder

WORKDIR /usr/src/rsky

RUN apt-get update && \
    apt-get install -y \
        git \
        curl \
        build-essential \
        libpq-dev \
        libssl-dev \
        pkg-config \
        libmariadb-dev \
        libmariadb-dev-compat \
        libsqlite3-dev && \
    rm -rf /var/lib/apt/lists/*

RUN git clone --depth 1 https://github.com/blacksky-algorithms/rsky.git .

RUN cargo build --release --package rsky-pds
WORKDIR /usr/src/rsky/rsky-pdsadmin
RUN cargo build --release

# ------------------------------
# Stage 2: Runtime
# ------------------------------
FROM debian:trixie-slim

WORKDIR /usr/src/rsky

RUN apt-get update && \
    apt-get install -y \
        ca-certificates \
        libpq5 \
        libssl3 \
        libldap2 \
        libsasl2-2 \
        libsasl2-modules \
        libsasl2-modules-db \
        libmariadb3 \
        libsqlite3-0 \
        build-essential \
        libpq-dev \
        pkg-config \
        curl && \
    rm -rf /var/lib/apt/lists/*

RUN curl https://sh.rustup.rs -sSf | sh -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"
RUN cargo install diesel_cli --version 2.2.12 --no-default-features --features postgres

COPY --from=builder /usr/src/rsky/target/release/rsky-pds ./rsky-pds
COPY --from=builder /usr/src/rsky/rsky-pdsadmin/target/release/pdsadmin ./pdsadmin
COPY --from=builder /usr/src/rsky/migrations ./migrations

RUN install -m 755 ./pdsadmin /usr/local/bin/pdsadmin && \
    ln -s /usr/local/bin/pdsadmin /bin/pdsadmin

ENV ROCKET_ADDRESS=0.0.0.0
ENV ROCKET_PORT=2583
ENV TZ=UTC
ENV PATH="/root/.cargo/bin:${PATH}"

EXPOSE 2583

# ------------------------------
# CMD: generate pds.env from runtime envs, init DB, run server
# ------------------------------
CMD ["sh", "-c", "\
    echo 'Generating pds.env from runtime environment...' && \
    cat > ./pds.env <<EOL
RUST_LOG=${RUST_LOG}
RUST_BACKTRACE=${RUST_BACKTRACE}
SERVICE_URL_RSKY_PDS_2583=${SERVICE_URL_RSKY_PDS_2583}
AWS_ENDPOINT=${AWS_ENDPOINT}
AWS_REGION=${AWS_REGION}
AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}
AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}
PDS_ADMIN_PASS=${PDS_ADMIN_PASS}
PDS_JWT_KEY_K256_PRIVATE_KEY_HEX=${PDS_JWT_KEY_K256_PRIVATE_KEY_HEX}
PDS_PLC_ROTATION_KEY_K256_PRIVATE_KEY_HEX=${PDS_PLC_ROTATION_KEY_K256_PRIVATE_KEY_HEX}
PDS_REPO_SIGNING_KEY_K256_PRIVATE_KEY_HEX=${PDS_REPO_SIGNING_KEY_K256_PRIVATE_KEY_HEX}
PDS_ADMIN_EMAIL=${PDS_ADMIN_EMAIL}
PDS_DATA_DIRECTORY=${PDS_DATA_DIRECTORY}
PDS_PORT=${PDS_PORT}
PDS_HOSTNAME=${PDS_HOSTNAME}
PDS_PROTOCOL=${PDS_PROTOCOL}
PDS_SERVICE_DID=${PDS_SERVICE_DID}
PDS_VERSION=${PDS_VERSION}
PDS_ACCEPTING_REPO_IMPORTS=${PDS_ACCEPTING_REPO_IMPORTS}
PDS_BLOB_UPLOAD_LIMIT=${PDS_BLOB_UPLOAD_LIMIT}
DATABASE_URL=${DATABASE_URL}
PDS_DID_PLC_URL=${PDS_DID_PLC_URL}
PDS_ID_RESOLVER_TIMEOUT=${PDS_ID_RESOLVER_TIMEOUT}
PDS_CONTACT_EMAIL_ADDRESS=${PDS_CONTACT_EMAIL_ADDRESS}
PDS_SERVICE_HANDLE_DOMAINS=${PDS_SERVICE_HANDLE_DOMAINS}
PDS_INVITE_REQUIRED=${PDS_INVITE_REQUIRED}
PDS_BSKY_APP_VIEW_DID=${PDS_BSKY_APP_VIEW_DID}
PDS_BSKY_APP_VIEW_URL=${PDS_BSKY_APP_VIEW_URL}
PDS_CRAWLERS=${PDS_CRAWLERS}
PDS_REPORT_SERVICE_DID=${PDS_REPORT_SERVICE_DID}
PDS_REPORT_SERVICE_URL=${PDS_REPORT_SERVICE_URL}
EOL
    echo 'Initializing database...' && \
    pdsadmin rsky-pds init-db && \
    echo 'Starting PDS server...' && \
    ./rsky-pds \
"]
