#!/usr/bin/env bash

set -e

cd /build/qemu

echo "Configuring QEMU for WebAssembly..."

emconfigure ./configure \
  --static \
  --target-list=x86_64-softmmu \
  --cpu=wasm32 \
  --enable-tcg \
  --disable-kvm \
  --disable-hvf \
  --disable-whpx \
  --disable-xen \
  --disable-linux-aio \
  --disable-libnfs \
  --disable-libiscsi \
  --disable-rbd \
  --disable-glusterfs \
  --disable-vnc \
  --disable-gtk \
  --disable-sdl \
  --disable-spice \
  --disable-curl \
  --disable-opengl \
  --disable-vte \
  --disable-docs \
  --disable-tools \
  --disable-guest-agent \
  --disable-debug-info \
  --disable-werror \
  --enable-slirp \
  --extra-cflags="-O3" \
  --extra-cxxflags="-O3" \
  --extra-ldflags="-s WASM_BIGINT=1 -s ALLOW_MEMORY_GROWTH=1"

echo
echo "QEMU configuration finished."