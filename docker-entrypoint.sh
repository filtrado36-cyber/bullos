#!/bin/sh
# Construye dentro del filesystem del contenedor (no en el volumen de macOS,
# que no soporta chroot/mknod) y copia la ISO final a /src/out.
set -e
cp -a /src/auto /src/config /work/
sh /src/artwork/render.sh /work/config
lb clean --purge >/dev/null 2>&1 || true
lb config
lb build
mkdir -p /src/out
cp -v /work/*.iso /src/out/
