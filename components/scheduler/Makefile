## Shared Makefile template for Go components.
## Copy to components/<name>/Makefile, then set COMPONENT and IMAGE.
##
## Usage:
##   make build         — compile static binary into ./bin/$(COMPONENT)
##   make test          — go vet + go test ./...
##   make lint          — gofmt -d + staticcheck
##   make image         — docker buildx build → $(IMAGE):$(VERSION)
##   make clean

# --- per-component variables (override in component Makefile) ---
COMPONENT ?= scheduler
IMAGE     ?= ghcr.io/$(ORG)/rancher-classic/$(COMPONENT)

# --- shared ---
ORG       ?= mtpark-ai
VERSION   ?= $(shell cat ../../VERSION 2>/dev/null || echo dev)
COMMIT    := $(shell git rev-parse --short HEAD 2>/dev/null || echo unknown)
DATE      := $(shell date -u +%Y-%m-%dT%H:%M:%SZ)

GOFLAGS   := -trimpath
LDFLAGS   := -s -w \
             -X main.version=$(VERSION) \
             -X main.commit=$(COMMIT) \
             -X main.date=$(DATE)

PLATFORM  ?= linux/amd64

.PHONY: all build test lint image clean tidy

all: build

build:
	@mkdir -p bin
	CGO_ENABLED=0 GOOS=linux go build $(GOFLAGS) -ldflags="$(LDFLAGS)" -o bin/$(COMPONENT) .

test:
	go vet ./...
	go test -race -count=1 ./...

lint:
	@test -z "$$(gofmt -l .)" || (gofmt -d . && exit 1)
	@command -v staticcheck >/dev/null || go install honnef.co/go/tools/cmd/staticcheck@latest
	staticcheck ./...

tidy:
	go mod tidy

image:
	docker buildx build \
	    --platform $(PLATFORM) \
	    --build-arg VERSION=$(VERSION) \
	    --build-arg COMMIT=$(COMMIT) \
	    --tag $(IMAGE):$(VERSION) \
	    --tag $(IMAGE):latest \
	    --load \
	    .

clean:
	rm -rf bin/
