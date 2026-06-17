#!/bin/bash
# AliDU System — installazione COMPLETA su Ubuntu/Debian con UN solo comando.
#
#   curl -fsSL https://alidarsilenzio.github.io/install-linux.sh | sudo bash
#
# Scarica le dipendenze, prende il pacchetto .deb da GitHub, lo installa e configura tutto.
set -e
DEB_URL="https://github.com/AliDarSilenzio/alidar-audio/releases/download/alidu-system-v1/alidu-system_1.0.0_all.deb"

if [ "$(id -u)" != "0" ]; then
  echo "Esegui con sudo:  curl -fsSL https://alidarsilenzio.github.io/install-linux.sh | sudo bash"
  exit 1
fi

echo "=================================================="
echo "   AliDU System — installazione su Ubuntu"
echo "=================================================="
echo ">> Dipendenze di sistema..."
apt-get update -qq
apt-get install -y wget curl python3 python3-venv python3-pip ffmpeg pandoc git zip fonts-dejavu

echo ">> Scarico il pacchetto da GitHub..."
TMP="$(mktemp -d)"
wget -qO "$TMP/alidu-system.deb" "$DEB_URL"

echo ">> Installo il pacchetto..."
apt-get install -y "$TMP/alidu-system.deb" || { dpkg -i "$TMP/alidu-system.deb"; apt-get -f install -y; }
rm -rf "$TMP"

echo ">> Configuro (ambiente Python, percorsi, font, gh)..."
alidu-setup

echo ""
echo "=================================================="
echo "   FATTO. Restano 2 cose tue (account):"
echo "   1) gh auth login"
echo "   2) metti client_secret.json in /Users/AgenteAliduEbook/progetti/alidar-studio/youtube/"
echo "      poi: /Users/AgenteAliduEbook/.tts_venv/bin/python \\"
echo "           /Users/AgenteAliduEbook/progetti/alidar-studio/rinnova_token.py"
echo "   3) automazioni: crontab -e  (vedi /opt/alidu-system/cron.example)"
echo "=================================================="
