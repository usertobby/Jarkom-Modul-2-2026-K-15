#!/bin/bash

ZONE_FILE="/etc/bind/jarkom/k15.com"
TARGET_DOMAIN="badssl.com."

echo "=== Menambahkan CNAME Record outbound ke $ZONE_FILE ==="

# Menambahkan baris CNAME record di bagian CNAME records
cat << 'EOF' >> "$ZONE_FILE"

outbound    IN  CNAME   badssl.com.
EOF
echo "-> CNAME record outbound berhasil ditambahkan."

# Otomatis menaikkan angka Serial SOA (format 10 digit angka)
SERIAL_LINE=$(grep -E '[0-9]{10}' "$ZONE_FILE" | head -n 1)
if [ ! -z "$SERIAL_LINE" ]; then
    CURRENT_SERIAL=$(echo "$SERIAL_LINE" | grep -oE '[0-9]{10}')
    NEW_SERIAL=$((CURRENT_SERIAL + 1))
    sed -i "s/$CURRENT_SERIAL/$NEW_SERIAL/g" "$ZONE_FILE"
    echo "-> Serial SOA dinaikkan dari $CURRENT_SERIAL menjadi $NEW_SERIAL."
fi

# Validasi zona DNS
echo "-> Menjalankan named-checkzone..."
named-checkzone k15.com "$ZONE_FILE"

if [ $? -eq 0 ]; then
    echo "-> Validasi sukses! Merestart layanan BIND9..."
    service named restart
    echo "=== Selesai! CNAME outbound berhasil diterapkan ==="
else
    echo "❌ Validasi gagal! Periksa kembali file zona."
fi