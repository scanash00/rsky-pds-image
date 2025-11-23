# Use specific Rust version from toolchain
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

# Clone the repository
RUN git clone --depth 1 https://github.com/blacksky-algorithms/rsky.git .

# Build the rsky-pds package
RUN cargo build --release --package rsky-pds

# Build the rsky-pdsadmin package (in its own workspace)
# Create a symlink so the embed_migrations! macro can find the migrations
RUN ln -s /app/rsky-pds /app/rsky-pdsadmin/rsky-pds
RUN cd rsky-pdsadmin && cargo build --release --features db_cli

# Install diesel_cli for running migrations
RUN cargo install diesel_cli --no-default-features --features postgres

# Runtime stage
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
COPY --from=builder /app/target/release/rsky-pds /usr/local/bin/rsky-pds
COPY --from=builder /app/rsky-pdsadmin/target/release/pdsadmin /usr/local/bin/pdsadmin
COPY --from=builder /usr/local/cargo/bin/diesel /usr/local/bin/diesel

# Copy migrations from the cloned repo
COPY --from=builder /app/rsky-pds/migrations /app/migrations

# Set default environment variables
ENV ROCKET_ADDRESS=0.0.0.0
ENV ROCKET_PORT=2583

CMD ["rsky-pds"]
