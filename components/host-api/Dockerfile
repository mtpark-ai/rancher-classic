# Shared Dockerfile template for Go components.
# Copy to components/<name>/Dockerfile and set COMPONENT.
#
# Builder stage uses Debian-based Go image (for CGO if ever needed).
# Runtime stage uses distroless static — smaller surface, no shell.

ARG GO_VERSION=1.22-bookworm
ARG RUNTIME_IMAGE=gcr.io/distroless/static-debian12:nonroot

# ------------- builder -------------
FROM golang:${GO_VERSION} AS builder

ARG COMPONENT=unset
ARG VERSION=dev
ARG COMMIT=unknown

WORKDIR /src
COPY go.mod go.sum ./
RUN go mod download

COPY . .

RUN --mount=type=cache,target=/root/.cache/go-build \
    CGO_ENABLED=0 GOOS=linux go build \
        -trimpath \
        -ldflags="-s -w \
                  -X main.version=${VERSION} \
                  -X main.commit=${COMMIT}" \
        -o /out/${COMPONENT} ./...

# ------------- runtime -------------
FROM ${RUNTIME_IMAGE}

ARG COMPONENT=unset
LABEL org.opencontainers.image.source="https://github.com/mtpark-ai/rancher-classic"
LABEL org.opencontainers.image.licenses="Apache-2.0"
LABEL io.rancher.container.system="${COMPONENT}"

COPY --from=builder /out/${COMPONENT} /usr/local/bin/entrypoint
USER nonroot
ENTRYPOINT ["/usr/local/bin/entrypoint"]
