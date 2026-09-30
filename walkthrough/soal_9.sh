#!/bin/bash

# Pastikan script dijalankan sebagai root
if [ "$EUID" -ne 0 ]; then
  echo "[-] Harap jalankan script ini sebagai root (sudo)!"
  exit 1
fi

echo "[+] Memperbarui daftar paket dan menginstal Apache2..."
apt-get update && apt-get install apache2 -y

echo "[+] Membuat direktori /arsip/ di DocumentRoot Apache..."
mkdir -p /var/www/html/arsip

echo "[+] Membuat beberapa file contoh di dalam /arsip/ untuk diuji..."
echo "Dokumen rahasia proyek K15" > /var/www/html/arsip/dokumen1.txt
echo "Laporan arsip bulanan" > /var/www/html/arsip/laporan.pdf
echo "Catatan penting server vault" > /var/www/html/arsip/catatan.txt

echo "[+] Membuat konfigurasi Apache untuk mengaktifkan autoindex pada /arsip/..."
cat <<EOF > /etc/apache2/conf-available/arsip-autoindex.conf
<Directory /var/www/html/arsip>
    Options Indexes FollowSymLinks
    AllowOverride None
    Require all granted
</Directory>
EOF

echo "[+] Mengaktifkan konfigurasi arsip-autoindex dan modul autoindex..."
a2enconf arsip-autoindex
a2enmod autoindex

echo "[+] Menyalakan dan me-restart layanan Apache2..."
service apache2 restart

echo "[+] Selesai! Layanan web statis dengan autoindex pada folder /arsip/ berhasil disiapkan."
echo "[+] Silakan lakukan pengujian menggunakan hostname (contoh: http://vault.k15.com/arsip/)."