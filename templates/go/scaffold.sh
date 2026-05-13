#!/usr/bin/env bash
## Materialize the Go templates into a component directory.
##
## Usage: ./templates/go/scaffold.sh <component>
##
## Idempotent: refuses to overwrite an existing Makefile/Dockerfile/go.mod
## unless --force is passed.

set -euo pipefail

if [ $# -lt 1 ]; then
    echo "usage: $0 <component> [--force]" >&2
    exit 2
fi

COMPONENT="$1"
FORCE=0
[ "${2:-}" = "--force" ] && FORCE=1

REPO_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
TPL_DIR="$REPO_ROOT/templates/go"
DEST="$REPO_ROOT/components/$COMPONENT"

if [ ! -d "$DEST" ]; then
    echo "error: $DEST does not exist" >&2
    exit 1
fi

emit() {
    local src="$1" dst="$2"
    if [ -f "$dst" ] && [ "$FORCE" -ne 1 ]; then
        echo "  skip   $dst (exists; pass --force to overwrite)"
        return
    fi
    sed -e "s|<COMPONENT>|${COMPONENT}|g" "$src" > "$dst"
    echo "  write  $dst"
}

emit "$TPL_DIR/Makefile.template"   "$DEST/Makefile"
emit "$TPL_DIR/Dockerfile.template" "$DEST/Dockerfile"
emit "$TPL_DIR/go.mod.template"     "$DEST/go.mod"

## set the COMPONENT default inside the Makefile
sed -i "s|^COMPONENT ?= unset|COMPONENT ?= ${COMPONENT}|" "$DEST/Makefile"

echo "scaffolded components/$COMPONENT"
