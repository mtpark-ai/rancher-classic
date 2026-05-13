# Shared Dockerfile template for Go components.
#
# Build context is the REPO ROOT (not the component directory), because
# components consume the locally-vendored third_party/ modules via go.mod
# replace directives.
#
# Build with:
#   docker buildx build --build-arg COMPONENT=<name> -f components/<name>/Dockerfile .

ARG GO_VERSION=1.22-bookworm
ARG RUNTIME_IMAGE=gcr.io/distroless/static-debian12:nonroot

# ------------- builder -------------
FROM golang:${GO_VERSION} AS builder

ARG COMPONENT=unset
ARG VERSION=dev
ARG COMMIT=unknown

WORKDIR /src

# Copy the vendored upstream modules first so Docker caches them
# independently of component churn.
COPY third_party/ /src/third_party/

# Component source.
COPY components/${COMPONENT}/ /src/components/${COMPONENT}/

WORKDIR /src/components/${COMPONENT}
RUN --mount=type=cache,target=/root/.cache/go-build \
    --mount=type=cache,target=/go/pkg/mod \
    go mod download

RUN --mount=type=cache,target=/root/.cache/go-build \
    --mount=type=cache,target=/go/pkg/mod \
    CGO_ENABLED=0 GOOS=linux go build \
        -trimpath \
        -ldflags="-s -w \
                  -X main.version=${VERSION} \
                  -X main.commit=${COMMIT}" \
        -o /out/${COMPONENT} .

# ------------- runtime -------------
FROM ${RUNTIME_IMAGE}

ARG COMPONENT=unset
LABEL org.opencontainers.image.source="https://github.com/mtpark-ai/rancher-classic"
LABEL org.opencontainers.image.licenses="Apache-2.0"
LABEL io.rancher.container.system="${COMPONENT}"

COPY --from=builder /out/${COMPONENT} /usr/local/bin/entrypoint
USER nonroot
ENTRYPOINT ["/usr/local/bin/entrypoint"]
