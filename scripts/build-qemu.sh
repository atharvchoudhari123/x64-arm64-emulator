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

docker rm -f browser-vm-qemu-export >/dev/null 2>&1 || true

docker create \
    --name browser-vm-qemu-export \
    browser-vm-qemu \
    >/dev/null

rm -rf "$ROOT/qemu"/*
mkdir -p "$ROOT/qemu"

docker cp \
    browser-vm-qemu-export:/build/output/qemu/. \
    "$ROOT/qemu/"

docker rm browser-vm-qemu-export >/dev/null

echo
echo "[3/4] Checking output..."

if ! find "$ROOT/qemu" -type f -name "*.wasm" -print -quit | grep -q .; then
    echo
    echo "ERROR: No .wasm file was produced."
    echo
    exit 1
fi

echo
echo "[4/4] QEMU-Wasm files:"
echo

find "$ROOT/qemu" -maxdepth 1 -type f -print

echo
echo "======================================"
echo " QEMU-Wasm build complete!"
echo "======================================"