#!/usr/bin/env bash

set -e

ROOT="$(cd "$(dirname "$0")/.." && pwd)"

echo "======================================"
echo " Browser VM - QEMU-Wasm Builder"
echo "======================================"

mkdir -p "$ROOT/qemu"

echo
echo "[1/4] Building QEMU-Wasm container..."

docker build \
  -f "$ROOT/Dockerfile.qemu" \
  -t browser-vm-qemu \
  "$ROOT"

echo
echo "[2/4] Extracting QEMU-Wasm..."

TEMP="$(mktemp -d)"

docker create \
  --name browser-vm-qemu-export \
  browser-vm-qemu \
  >/dev/null

docker cp \
  browser-vm-qemu-export:/build/output/qemu/. \
  "$ROOT/qemu/"

docker rm browser-vm-qemu-export >/dev/null

rm -rf "$TEMP"

echo
echo "[3/4] Checking output..."

if ! find "$ROOT/qemu" -type f | grep -q '\.wasm$'; then
  echo
  echo "ERROR: No .wasm file was produced."
  echo
  echo "The QEMU build completed without producing"
  echo "the browser runtime expected by the bootloader."
  exit 1
fi

echo
echo "[4/4] QEMU-Wasm files:"
echo

find "$ROOT/qemu" -maxdepth 1 -type f -printf "  %f\n" 2>/dev/null || \
find "$ROOT/qemu" -maxdepth 1 -type f

echo
echo "======================================"
echo " QEMU-Wasm build complete!"
echo "======================================"