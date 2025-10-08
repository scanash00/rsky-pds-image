# ------------------------------
# Stage 1: Builder
# ------------------------------
FROM rust:latest AS builder

WORKDIR /usr/src/rsky

# Install build dependencies
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

# Clone repository
RUN git clone --depth 1 https://github.com/blacksky-algorithms/rsky.git .

# Build rsky-pds binary explicitly
WORKDIR /usr/src/rsky/rsky-pds
RUN cargo build --release --bin rsky-pds

# Build rsky-pdsadmin binary explicitly
WORKDIR /usr/src/rsky/rsky-pdsadmin
RUN cargo build --release --bin rsky-pdsadmin

# ------------------------------
# Stage 2: Runtime
# ------------------------------
FROM debian:trixie-slim

WORKDIR /usr/src/rsky

# Install runtime dependencies
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
    && rm -rf /var/lib/apt/lists/*

# Copy binaries from builder (paths now guaranteed)
COPY --from=builder /usr/src/rsky/rsky-pds/target/release/rsky-pds ./rsky-pds
COPY --from=builder /usr/src/rsky/rsky-pdsadmin/target/release/rsky-pdsadmin ./rsky-pdsadmin

# Make sure pdsadmin has a pds.env placeholder
RUN install -m 755 ./rsky-pdsadmin /usr/local/bin/rsky-pdsadmin && touch ./pds.env

# Metadata label
LABEL org.opencontainers.image.source="https://github.com/blacksky-algorithms/rsky"

# Environment configuration
ENV ROCKET_ADDRESS=0.0.0.0
ENV ROCKET_PORT=2583
ENV TZ=UTC

# Expose default port
EXPOSE 2583

# Start the PDS server by default
CMD ["./rsky-pds"]
