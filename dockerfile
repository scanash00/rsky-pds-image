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

RUN cargo install diesel_cli --no-default-features --features postgres --version 2.2.12

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
        postgresql-client \
        procps \
        bash && \
    rm -rf /var/lib/apt/lists/*

COPY --from=builder /usr/src/rsky/target/release/rsky-pds ./rsky-pds
COPY --from=builder /usr/src/rsky/rsky-pdsadmin/target/release/pdsadmin ./pdsadmin
COPY --from=builder /root/.cargo/bin/diesel ./diesel

COPY --from=builder /usr/src/rsky/migrations ./migrations

COPY entrypoint.sh /usr/src/rsky/entrypoint.sh
RUN chmod +x /usr/src/rsky/entrypoint.sh

ENV ROCKET_ADDRESS=0.0.0.0
ENV ROCKET_PORT=2583
ENV TZ=UTC
ENV PATH="/usr/src/rsky:$PATH"

EXPOSE 2583

CMD ["/usr/src/rsky/entrypoint.sh"]
