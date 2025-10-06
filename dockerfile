# ------------------------------
# Stage 1: Builder
# ------------------------------
FROM rust:latest AS builder

WORKDIR /usr/src/rsky

# Clone the repository
RUN git clone --depth 1 https://github.com/blacksky-algorithms/rsky.git .

# Optional: create dummy main.rs if needed (sometimes for Cargo workspace)
# RUN mkdir -p rsky-pds/src && echo "fn main() {}" > rsky-pds/src/main.rs

# Build final release binary
RUN cargo build --release --package rsky-pds

# ------------------------------
# Stage 2: Runtime
# ------------------------------
FROM debian:bullseye-slim

WORKDIR /usr/src/rsky

RUN apt-get update && apt-get install -y ca-certificates && rm -rf /var/lib/apt/lists/*

COPY --from=builder /usr/src/rsky/target/release/rsky-pds ./rsky-pds

LABEL org.opencontainers.image.source=https://github.com/blacksky-algorithms/rsky

ENV ROCKET_ADDRESS=0.0.0.0
ENV ROCKET_PORT=2583

CMD ["./rsky-pds"]
