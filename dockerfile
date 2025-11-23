# =========================
# Builder Stage
# =========================
FROM rust:1.86-slim-bullseye AS builder

WORKDIR /app

# Install build dependencies including PostgreSQL client libraries
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

# Force cache bust when repo updates
# (does NOT populate the directory, so clone won't fail)
ADD https://api.github.com/repos/scanash00/rsky/git/refs/heads/main version.json

# Clone the repository into a clean directory
RUN git clone --depth 1 https://github.com/scanash00/rsky.git src
WORKDIR /app/src

# Build the rsky-pds package
RUN cargo build --release --package rsky-pds

# Build the rsky-pdsadmin package (workspace aware)
RUN ln -s /app/src/rsky-pds /app/src/rsky-pdsadmin/rsky-pds
RUN cd rsky-pdsadmin && cargo build --release --features db_cli

# Install diesel_cli for running migrations
RUN cargo install diesel_cli --no-default-features --features postgres

# =========================
# Runtime Stage
# =========================
FROM debian:bullseye-slim

WORKDIR /app

# Install runtime dependencies including PostgreSQL client library
RUN apt-get update && \
    apt-get install -y \
        ca-certificates \
        libpq5 \
        libssl1.1 \
        libldap-2.4-2 \
        libsasl2-2 \
        libsasl2-modules \
        libsasl2-modules-db \
        libmariadb3 \
        libsqlite3-0 \
        postgresql-client \
        procps \
        bash && \
    rm -rf /var/lib/apt/lists/*

# Copy the binaries from builder
COPY --from=builder /app/src/target/release/rsky-pds /usr/local/bin/rsky-pds
COPY --from=builder /app/src/rsky-pdsadmin/target/release/pdsadmin /usr/local/bin/pdsadmin
COPY --from=builder /usr/local/cargo/bin/diesel /usr/local/bin/diesel

# Copy migrations
COPY --from=builder /app/src/rsky-pds/migrations /app/migrations

# Set default environment variables
ENV ROCKET_ADDRESS=0.0.0.0
ENV ROCKET_PORT=2583

CMD ["rsky-pds"]
