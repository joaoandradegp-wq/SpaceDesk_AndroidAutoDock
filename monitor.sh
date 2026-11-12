#!/data/data/com.termux/files/usr/bin/bash
# Tablet Spacedesk Clock
# PC ligado  -> abre o spacedesk
# PC desligado -> volta para o app de relogio

unset LD_PRELOAD

# ---- CONFIGURACAO ----
PC_NOME="192.168.0.10"        # IP do PC (use IP fixo no roteador)
SPACEDESK_ATIV="ph.spacedesk.beta/ph.spacedesk.httpwww.spacedesk.SAActivityConnect"
RELOGIO_ATIV="com.cama.app.huge80sclockPro/com.cama.app.huge80sclockPro.MainActivity"
INTERVALO=5                   # segundos entre verificacoes
FALHAS_PARA_DESLIGAR=3        # falhas seguidas ate voltar ao relogio
# ----------------------

termux-wake-lock

abrir_app() {
  PATH=/system/bin:$PATH LD_LIBRARY_PATH= /system/bin/am start --user 0 -n "$1" -f 0x00020000 >/dev/null 2>&1
}

estado="off"
falhas=0

while true; do
  if ping -c 1 -W 2 "$PC_NOME" >/dev/null 2>&1; then
    falhas=0
    if [ "$estado" = "off" ]; then
      estado="on"
      echo "$(date +%T) PC online, abrindo spacedesk"
      abrir_app "$SPACEDESK_ATIV"
    fi
  else
    falhas=$((falhas + 1))
    if [ "$estado" = "on" ] && [ "$falhas" -ge "$FALHAS_PARA_DESLIGAR" ]; then
      estado="off"
      echo "$(date +%T) PC offline, voltando ao relogio"
      abrir_app "$RELOGIO_ATIV"
    fi
  fi
  sleep "$INTERVALO"
done