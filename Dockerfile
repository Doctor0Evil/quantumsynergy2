# syntax=docker/dockerfile:1.7

########################
# Builder stage
########################
FROM debian:stable-slim AS builder

ARG ALN_VERSION=6.0.0

ENV DEBIAN_FRONTEND=noninteractive \
    APP_HOME=/app

WORKDIR ${APP_HOME}

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
       ca-certificates curl build-essential \
    && rm -rf /var/lib/apt/lists/*

# Placeholder for ALN toolchain / build
# In a real pipeline, install the ALN compiler/SDK here.
# Example:
# RUN curl -fsSL https://downloads.quantumsynergy.example/aln-${ALN_VERSION}.tar.gz \
#   | tar xz -C /usr/local

COPY src ./src

# Example build step; replace with actual ALN compilation once toolchain is available.
RUN mkdir -p dist \
    && echo '#!/usr/bin/env bash' > dist/aln-core \
    && echo 'echo "Starting ALN core ${ALN_VERSION} (stub binary)"' >> dist/aln-core \
    && echo 'while true; do echo "ok"; sleep 60; done' >> dist/aln-core \
    && chmod +x dist/aln-core

########################
# Runtime stage
########################
FROM gcr.io/distroless/base-debian12 AS runtime

ENV APP_HOME=/app \
    ALN_ENV=production \
    ALN_VERSION=6.0.0

WORKDIR ${APP_HOME}

COPY --from=builder /app/dist/aln-core /usr/local/bin/aln-core

EXPOSE 8080

USER 65532:65532

ENTRYPOINT ["/usr/local/bin/aln-core"]
