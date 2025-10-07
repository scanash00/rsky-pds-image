# ------------------------------
# Stage 1: Builder
# ------------------------------
FROM rust:latest AS builder

WORKDIR /usr/src/rsky

RUN git clone --depth 1 https://github.com/blacksky-algorithms/rsky.git .

RUN cargo build --release --package rsky-pds

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
    && rm -rf /var/lib/apt/lists/*

COPY --from=builder /usr/src/rsky/target/release/rsky-pds ./rsky-pds

LABEL org.opencontainers.image.source=https://github.com/blacksky-algorithms/rsky

ENV ROCKET_ADDRESS=0.0.0.0
ENV ROCKET_PORT=2583
ENV TZ=UTC

CMD ["./rsky-pds"]
