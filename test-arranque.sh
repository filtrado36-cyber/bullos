#!/bin/sh
# Arranca la ISO en QEMU (UEFI, sin aceleración) dentro de Docker y guarda
# capturas de pantalla periódicas en out/capturas/. Sirve para revisar el menú
# de arranque, la animación de Plymouth y el inicio de sesión sin abrir UTM.
# Uso: ./test-arranque.sh [segundos]   (por defecto 240)
set -e
cd "$(dirname "$0")"
DURACION=${1:-240}
mkdir -p out/capturas
rm -f out/capturas/*.png
docker run --rm -v "$PWD/out":/o debian:trixie sh -c "
set -e
apt-get update -qq >/dev/null
apt-get install -y -qq --no-install-recommends qemu-system-x86 ovmf socat imagemagick >/dev/null
cp /usr/share/OVMF/OVMF_VARS_4M.fd /tmp/vars.fd
qemu-system-x86_64 -m 4096 -smp 4 -machine q35 -vga virtio \
  -drive if=pflash,format=raw,readonly=on,file=/usr/share/OVMF/OVMF_CODE_4M.fd \
  -drive if=pflash,format=raw,file=/tmp/vars.fd \
  -cdrom /o/bullos-amd64.hybrid.iso -display none \
  -monitor unix:/tmp/mon,server,nowait -daemonize
t=0
while [ \$t -lt $DURACION ]; do
  sleep 4; t=\$((t+4))
  # Enter en el menú de GRUB por si espera
  [ \$t -eq 20 ] && echo 'sendkey ret' | socat - unix-connect:/tmp/mon >/dev/null
  f=\$(printf '/tmp/c%03d.ppm' \$t)
  echo \"screendump \$f\" | socat - unix-connect:/tmp/mon >/dev/null
  sleep 1; [ -f \$f ] && convert \$f -resize 50% \$(printf '/o/capturas/%03d.png' \$t)
done
echo quit | socat - unix-connect:/tmp/mon >/dev/null || true
"
ls out/capturas | wc -l
