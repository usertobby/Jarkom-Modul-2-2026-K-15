#!/bin/bash

ZONE_FILE="/etc/bind/jarkom/k15.com"
NEW_IP="10.71.3.99"

echo "=== Memperbarui A Record Abbey di Prab ==="

# 1. Mengubah baris abbey menjadi TTL 15 detik dan IP fiktif
sed -i -E "s/^(abbey\s+)(IN|[0-9]+\s+IN)(\s+A\s+)[0-9.]+.*/abbey\t15\tIN\tA\t$NEW_IP/" "$ZONE_FILE"
echo "-> A record abbey berhasil diubah ke IP $NEW_IP dengan TTL 15 detik."

# 2. Otomatis menaikkan angka Serial SOA (format 10 digit angka)
SERIAL_LINE=$(grep -E '[0-9]{10}' "$ZONE_FILE" | head -n 1)
if [ ! -z "$SERIAL_LINE" ]; then
    CURRENT_SERIAL=$(echo "$SERIAL_LINE" | grep -oE '[0-9]{10}')
    NEW_SERIAL=$((CURRENT_SERIAL + 1))
    sed -i "s/$CURRENT_SERIAL/$NEW_SERIAL/g" "$ZONE_FILE"
    echo "-> Serial SOA dinaikkan dari $CURRENT_SERIAL menjadi $NEW_SERIAL."
fi

# 3. Validasi zona DNS
echo "-> Menjalankan named-checkzone..."
named-checkzone k15.com "$ZONE_FILE"

if [ $? -eq 0 ]; then
    echo "-> Validasi sukses! Merestart layanan BIND9..."
    service named restart
    echo "=== Selesai! Konfigurasi prab berhasil diterapkan ==="
else
    echo "❌ Validasi gagal! Periksa kembali file zona."
fi