#!/bin/bash

# Path file zona DNS k15.com
ZONE_FILE="/etc/bind/jarkom/k15.com"

echo "Menambahkan TXT records untuk klien ke $ZONE_FILE..."

# Menambahkan baris TXT record di bagian akhir file
cat << 'EOF' >> "$ZONE_FILE"

; --- TXT Records untuk Klien Sayap Kiri & Kanan ---
alpha       IN  TXT     "alpha"
beta        IN  TXT     "beta"
gamma       IN  TXT     "gamma"
delta       IN  TXT     "delta"
epsilon     IN  TXT     "epsilon"
EOF

echo "Selesai! Jangan lupa untuk menaikkan angka Serial di bagian atas file zona."
echo "Setelah itu jalankan perintah validasi dan restart:"
echo "  named-checkzone k15.com /etc/bind/jarkom/k15.com"
echo "  service named restart"