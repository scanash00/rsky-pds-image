# Use specific Rust version from toolchain
FROM rust:1.86-slim-bullseye AS builder

WORKDIR /app

# Install build dependencies
RUN apt-get update && apt-get install -y pkg-config libssl-dev git && rm -rf /var/lib/apt/lists/*

# Copy the entire workspace
# We assume the build context is the workspace root
COPY . .

# Build the rsky-pds package
RUN cargo build --release --package rsky-pds

# Runtime stage
FROM debian:bullseye-slim

WORKDIR /app

# Install runtime dependencies
RUN apt-get update && apt-get install -y ca-certificates libssl1.1 && rm -rf /var/lib/apt/lists/*

# Copy the binary from builder
COPY --from=builder /app/target/release/rsky-pds /usr/local/bin/rsky-pds

# Copy migrations and configuration
COPY rsky-pds/migrations /app/migrations
COPY rsky-pds/diesel.toml /app/diesel.toml

# Set default environment variables
ENV ROCKET_ADDRESS=0.0.0.0
ENV ROCKET_PORT=2583

CMD ["rsky-pds"]
