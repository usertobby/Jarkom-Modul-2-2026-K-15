#!/bin/bash

# ==========================================================
# SOAL 14 - Forward Client IP
# Node     : PENNY
# Service  : Apache
# Backend  : Obladi & Desmond
# ==========================================================

echo "[+] Mengonfigurasi Penny..."

# Pastikan module headers aktif
a2enmod headers

# Backup konfigurasi sebelum diubah
cp /etc/apache2/sites-available/vault-proxy.conf \
   /etc/apache2/sites-available/vault-proxy.conf.bak

# Mengubah forwarding X-Real-IP menjadi format expression
sed -i 's|RequestHeader set X-Real-IP.*|RequestHeader set X-Real-IP expr=%{REMOTE_ADDR}|' \
/etc/apache2/sites-available/vault-proxy.conf

echo "[+] Mengecek konfigurasi Apache..."

apache2ctl configtest

if [ $? -ne 0 ]; then
    echo "[-] Konfigurasi Apache gagal."
    echo "[-] Konfigurasi backup tidak dihapus."
    exit 1
fi

echo "[+] Restart Apache..."

service apache2 restart

echo
echo "[+] =========================================="
echo "[+] SOAL 14 - PENNY SELESAI"
echo "[+] =========================================="
echo "[+] X-Real-IP diteruskan dari client."
echo "[+] Backend : 10.71.3.4 / 10.71.3.5"
echo "[+] =========================================="