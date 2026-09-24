FROM debian:trixie
RUN apt-get update && apt-get install -y --no-install-recommends \
      live-build debootstrap squashfs-tools xorriso isolinux syslinux-common \
      grub-efi-amd64-bin grub-pc-bin mtools dosfstools ca-certificates \
      librsvg2-bin fonts-dejavu-core \
    && rm -rf /var/lib/apt/lists/*
WORKDIR /work
COPY docker-entrypoint.sh /usr/local/bin/
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
