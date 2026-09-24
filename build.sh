#!/bin/sh
# Genera la ISO en ./out usando Docker.
set -e
cd "$(dirname "$0")"
docker build -t bullos-builder .
docker run --rm --privileged -v "$PWD":/src bullos-builder
ls -lh out/*.iso
