#!/bin/sh
# Genera todo el arte de BullOS a partir de logo.svg.
# Uso: render.sh <directorio config/ de live-build>
# Requiere rsvg-convert y fuentes DejaVu (vienen en la imagen Docker).
set -e
HERE=$(cd "$(dirname "$0")" && pwd)
CFG="$1"
ROOT="$CFG/includes.chroot"
THEME="$ROOT/usr/share/desktop-base/bullos-theme"
CALA="$ROOT/etc/calamares/branding/bullos"
TMP=$(mktemp -d)

# Paleta
BG1="#2A1D14"; BG2="#120C09"; ACCENT="#E0762B"; CREAM="#F3E6D3"

LOGO=$(sed -n '/<g id="bull">/,/^<\/g>/p' "$HERE/logo.svg")
# logo <x> <y> <tamaño>
logo() { echo "<g transform=\"translate($1 $2) scale($(echo "$3" | awk '{print $1/256}'))\">$LOGO</g>"; }
# fondo <ancho> <alto>
fondo() {
  cat <<X
<defs><radialGradient id="g" cx="50%" cy="45%" r="75%">
  <stop offset="0" stop-color="$BG1"/><stop offset="1" stop-color="$BG2"/></radialGradient></defs>
<rect width="$1" height="$2" fill="url(#g)"/>
<ellipse cx="$(($1/2))" cy="$2" rx="$(($1*6/10))" ry="$(($2/4))" fill="$ACCENT" opacity="0.10"/>
X
}
texto() { # <x> <y> <tamaño> <texto> [color]
  echo "<text x=\"$1\" y=\"$2\" font-family=\"DejaVu Sans\" font-weight=\"bold\" font-size=\"$3\" letter-spacing=\"$(($3/12))\" text-anchor=\"middle\" fill=\"${5:-$CREAM}\">$4</text>"
}
svg() { echo "<svg xmlns=\"http://www.w3.org/2000/svg\" width=\"$1\" height=\"$2\" viewBox=\"0 0 $1 $2\">"; }

mkdir -p "$THEME/wallpaper/contents/images" "$THEME/login" "$THEME/grub" \
         "$CALA" "$ROOT/usr/share/pixmaps" "$CFG/bootloaders"

# Fondo de escritorio
{ svg 1920 1080; fondo 1920 1080; logo 800 300 320; texto 960 720 96 BullOS; echo "</svg>"; } \
  > "$THEME/wallpaper/contents/images/1920x1080.svg"

# Paquete de fondo de pantalla para Plasma
WP="$ROOT/usr/share/wallpapers/BullOS"
mkdir -p "$WP/contents/images"
cp "$THEME/wallpaper/contents/images/1920x1080.svg" "$WP/contents/images/"
cat > "$WP/metadata.json" <<X
{ "KPlugin": { "Id": "BullOS", "Name": "BullOS", "License": "CC-BY-SA-4.0",
  "Authors": [ { "Name": "BullOS" } ] } }
X

# Fondo del login (el cuadro de login va al centro: logo arriba)
{ svg 1920 1080; fondo 1920 1080; logo 880 70 160; echo "</svg>"; } > "$THEME/login/background.svg"
# SDDM pone reloj y usuario al centro: logo abajo a la derecha
{ svg 1920 1080; fondo 1920 1080; logo 1660 820 200; echo "</svg>"; } > "$THEME/login/sddm.svg"

# Animación de arranque (Plymouth): bull terrier persiguiéndose la cola, visto
# desde arriba. Dos cuadros con las patas alternadas; el script de Plymouth los
# rota alrededor del centro.
PLY="$ROOT/usr/share/plymouth/themes/bullos"
LNF="$ROOT/usr/share/plasma/look-and-feel/org.bullos.desktop/contents/splash/images"
mkdir -p "$PLY" "$LNF"
sh "$HERE/perro-giro.sh" 0 > "$TMP/perro-1.svg"
sh "$HERE/perro-giro.sh" 1 > "$TMP/perro-2.svg"
rsvg-convert -w 240 -h 240 "$TMP/perro-1.svg" -o "$PLY/perro-1.png"
rsvg-convert -w 240 -h 240 "$TMP/perro-2.svg" -o "$PLY/perro-2.png"
{ svg 300 70; texto 150 52 44 BullOS; echo "</svg>"; } > "$TMP/titulo.svg"
rsvg-convert "$TMP/titulo.svg" -o "$PLY/titulo.png"

# Foto de perfil predeterminada de los usuarios
{ svg 256 256; echo "<circle cx=\"128\" cy=\"128\" r=\"128\" fill=\"$BG1\"/>"; logo 28 24 200; echo "</svg>"; } > "$TMP/face.svg"
mkdir -p "$ROOT/usr/share/bullos"
rsvg-convert "$TMP/face.svg" -o "$ROOT/usr/share/bullos/face.png"

# Pantalla de carga de Plasma
rsvg-convert -w 360 -h 360 "$HERE/logo.svg" -o "$LNF/logo.png"

# Fondo de GRUB del sistema instalado (logo abajo a la derecha, no tapa el menú)
{ svg 1920 1080; fondo 1920 1080; logo 1660 820 200; echo "</svg>"; } > "$TMP/grub.svg"
rsvg-convert -w 1920 -h 1080 "$TMP/grub.svg" -o "$THEME/grub/grub-16x9.png"
rsvg-convert -w 1024 -h 768  "$TMP/grub.svg" -o "$THEME/grub/grub-4x3.png"
cat > "$THEME/grub/grub_background.sh" <<X
WALLPAPER=/usr/share/images/desktop-base/desktop-grub.png
COLOR_NORMAL=light-gray/black
COLOR_HIGHLIGHT=white/brown
X

# Menú de arranque de la ISO (live-build lo convierte a PNG)
{ svg 640 480; fondo 640 480; logo 265 22 110; texto 320 172 30 BullOS; echo "</svg>"; } \
  > "$CFG/bootloaders/splash.svg"

# Calamares e íconos
rsvg-convert -w 256 -h 256 "$HERE/logo.svg" -o "$CALA/logo.png"
rsvg-convert -w 128 -h 128 "$HERE/logo.svg" -o "$ROOT/usr/share/pixmaps/bullos.png"
{ svg 600 300; logo 190 0 220; texto 300 290 56 BullOS "$ACCENT"; echo "</svg>"; } > "$TMP/welcome.svg"
rsvg-convert "$TMP/welcome.svg" -o "$CALA/welcome.png"
{ svg 934 560; fondo 934 560; logo 347 60 240; texto 467 390 64 BullOS
  texto 467 450 26 "Gracias por elegir BullOS" "$ACCENT"; echo "</svg>"; } > "$TMP/slide.svg"
rsvg-convert "$TMP/slide.svg" -o "$CALA/slide1.png"

rm -rf "$TMP"
echo "Arte de BullOS generado."
