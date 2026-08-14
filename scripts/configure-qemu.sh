#!/usr/bin/env bash

set -e

echo "======================================"
echo " Configuring QEMU for WebAssembly"
echo "======================================"

cd /build/qemu

export CC=emcc
export CXX=em++
export AR=emar
export RANLIB=emranlib
export LD=emcc

export CFLAGS="-O3 -DEMSCRIPTEN"
export CXXFLAGS="-O3 -DEMSCRIPTEN"
export LDFLAGS="-sWASM_BIGINT=1 -sALLOW_MEMORY_GROWTH=1"

export PKG_CONFIG="/usr/bin/pkg-config"

export PKG_CONFIG_PATH="/build/sysroot/lib/pkgconfig:/build/sysroot/share/pkgconfig"

export PKG_CONFIG_LIBDIR="/build/sysroot/lib/pkgconfig:/build/sysroot/share/pkgconfig"

./configure \
    --static \
    --target-list=x86_64-softmmu \
    --cpu=wasm32 \
    --cross-prefix= \
    --enable-tcg \
    --enable-tcg-interpreter \
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
    --disable-pie \
    --disable-slirp

echo
echo "QEMU configuration completed."