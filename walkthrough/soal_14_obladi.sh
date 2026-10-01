#!/bin/bash

# ==========================================================
# SOAL 14 - Forward Client IP
# Node     : OBLADI
# Service  : Apache
# Proxy    : Penny (10.71.4.2)
# ==========================================================

echo "[+] Mengaktifkan mod_remoteip..."

a2enmod remoteip

echo "[+] Membuat konfigurasi Remote IP..."

cat << 'EOF' > /etc/apache2/conf-available/remoteip.conf
RemoteIPHeader X-Real-IP
RemoteIPInternalProxy 10.71.4.2
EOF

echo "[+] Mengaktifkan konfigurasi remoteip..."

a2enconf remoteip

echo "[+] Mengecek konfigurasi Apache..."

apache2ctl configtest

if [ $? -ne 0 ]; then
    echo "[-] Konfigurasi Apache gagal."
    exit 1
fi

echo "[+] Restart Apache..."

service apache2 restart

echo
echo "[+] =========================================="
echo "[+] SOAL 14 - OBLADI SELESAI"
echo "[+] =========================================="
echo "[+] Header   : X-Real-IP"
echo "[+] Proxy    : 10.71.4.2"
echo "[+] =========================================="