#!/usr/bin/env bash

set -euo pipefail

echo "======================================"
echo "  Building Wurst-Client-1.8-ts"
echo "======================================"

if ! command -v pnpm >/dev/null 2>&1; then
    echo "pnpm not found → falling back to npm"
    RUNNER="npm run"
else
    RUNNER="pnpm"
fi

echo "→ Installing dependencies (if needed)..."
$RUNNER install --frozen-lockfile

echo "→ Cleaning previous build artifacts..."
rm -rf dist build .turbo node_modules/.cache packages/*/dist 2>/dev/null || true

echo "→ Running build..."
$RUNNER build

echo ""
if [ -d "dist" ] || find packages -type d -name "dist" -print -quit | grep -q .; then
    echo "Build finished successfully."
    echo "Output locations:"
    [ -d "dist" ] && echo "  • Root: ./dist"
    find packages -type d -name "dist" -print | sed 's/^/  • /'
else
    echo "Warning: No dist folders found after build."
fi

echo "Done."