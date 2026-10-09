#!/usr/bin/env bash
# Renders diagrams/*.mmd to assets/*.svg with pinned mermaid-cli. Linux and macOS.
# Same contract as tools/render-mermaid.ps1. Run from the repo root.
# Usage: tools/render-mermaid.sh [atlas_dir]
# Needs: node 18+ (npx), network once for the mermaid-cli download and its browser.
set -euo pipefail
ATLAS="${1:-docs/atlas}"
DIAG="$ATLAS/diagrams"
OUT="$ATLAS/assets"
VERSION="12.0.0"
CFG="tools/mermaid-config.json"
[ -d "$DIAG" ] || { echo "no diagrams dir at $DIAG"; exit 1; }
command -v npx >/dev/null || { echo "node/npx required, see README"; exit 1; }
shopt -s nullglob
files=("$DIAG"/*.mmd)
[ "${#files[@]}" -gt 0 ] || { echo "no .mmd files in $DIAG"; exit 1; }
for f in "${files[@]}"; do
  base="$(basename "$f" .mmd)"
  if [ -f "$CFG" ]; then
    npx -y "@mermaid-js/mermaid-cli@$VERSION" -i "$f" -o "$OUT/$base.svg" --scale 2 --configFile "$CFG"
  else
    npx -y "@mermaid-js/mermaid-cli@$VERSION" -i "$f" -o "$OUT/$base.svg" --scale 2
  fi
  echo "$f -> $OUT/$base.svg"
done
echo "done: ${#files[@]} renders in $OUT"
