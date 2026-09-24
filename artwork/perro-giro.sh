#!/bin/sh
# Bull terrier visto desde arriba, corriendo en círculo detrás de su cola.
# Uso: perro-giro.sh <0|1>   (cuadro de la carrera: patas alternadas)
#
# Todo se dibuja sobre un círculo de radio 52 centrado en (100,100). Cada parte
# se ubica rotando el grupo al ángulo deseado: en el marco local la parte está
# en (152,100) y el perro avanza hacia +y (sentido horario).
CREAM="#F3E6D3"; ACCENT="#E0762B"; DARK="#16110D"

if [ "$1" = 1 ]; then DE=270; DI=292; TE=88; TI=66
else                  DE=292; DI=270; TE=66; TI=88; fi

pata() { # <ángulo> <cx>
    echo "<ellipse transform=\"rotate($1 100 100)\" cx=\"$2\" cy=\"100\" rx=\"12\" ry=\"6.5\" fill=\"$CREAM\" stroke=\"$DARK\" stroke-width=\"3\"/>"
}

cat <<EOF
<svg xmlns="http://www.w3.org/2000/svg" width="200" height="200" viewBox="0 0 200 200">
  <!-- patas: delanteras y traseras, exterior (r~72) e interior (r~30) -->
  $(pata $DE 170) $(pata $DI 131)
  $(pata $TE 170) $(pata $TI 131)
  <!-- cola: fina, casi alcanzada por la cabeza -->
  <circle cx="100" cy="100" r="52" fill="none" stroke="$DARK" stroke-width="10"
          stroke-linecap="round" stroke-dasharray="30 400" transform="rotate(10 100 100)"/>
  <circle cx="100" cy="100" r="52" fill="none" stroke="$CREAM" stroke-width="5"
          stroke-linecap="round" stroke-dasharray="30 400" transform="rotate(10 100 100)"/>
  <!-- cuerpo: arco grueso de 260° -->
  <circle cx="100" cy="100" r="52" fill="none" stroke="$DARK" stroke-width="31"
          stroke-linecap="round" stroke-dasharray="236 400" transform="rotate(40 100 100)"/>
  <circle cx="100" cy="100" r="52" fill="none" stroke="$CREAM" stroke-width="25"
          stroke-linecap="round" stroke-dasharray="236 400" transform="rotate(40 100 100)"/>
  <!-- mancha en el lomo -->
  <ellipse transform="rotate(165 100 100)" cx="152" cy="100" rx="9" ry="16" fill="$ACCENT"/>
  <!-- cabeza ovalada con orejas en punta -->
  <g transform="rotate(313 100 100)" stroke="$DARK" stroke-width="3" stroke-linejoin="round">
    <path d="M137 98 L128 74 L152 88 Z" fill="$CREAM"/>
    <path d="M167 98 L176 74 L152 88 Z" fill="$CREAM"/>
    <ellipse cx="152" cy="107" rx="20" ry="28" fill="$CREAM"/>
    <ellipse cx="161" cy="113" rx="8.5" ry="10.5" fill="$ACCENT" stroke="none"/>
    <path d="M141 112 L149 115 L142 118 Z" fill="$DARK" stroke="none"/>
    <path d="M164 112 L156 115 L163 118 Z" fill="$DARK" stroke="none"/>
    <ellipse cx="152" cy="132" rx="6" ry="4.2" fill="$DARK" stroke="none"/>
  </g>
</svg>
EOF
