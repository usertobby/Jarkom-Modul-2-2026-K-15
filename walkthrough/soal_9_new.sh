#!/bin/bash

# Pastikan script dijalankan sebagai root
if [ "$EUID" -ne 0 ]; then
  echo "[-] Harap jalankan script ini sebagai root!"
  exit 1
fi

echo "[*] Menginstal paket Apache2..."
apt-get update && apt-get install apache2 -y

echo "[*] Menyiapkan direktori /var/www/html/arsip/..."
mkdir -p /var/www/html/arsip

# Buat file index sederhana di root sebagai penanda node
NODE_NAME=$(hostname)
echo "<h1>Selamat Datang di Web Vault ($NODE_NAME)</h1>" > /var/www/html/index.html

# Buat file contoh di dalam /arsip/
echo "Dokumen rahasia proyek K15 - Server $NODE_NAME" > /var/www/html/arsip/dokumen1.txt
echo "Laporan arsip bulanan K15" > /var/www/html/arsip/laporan.pdf
echo "Catatan penting server $NODE_NAME" > /var/www/html/arsip/catatan.txt

echo "[*] Menyetel hak akses direktori..."
chown -R www-data:www-data /var/www/html
chmod -R 755 /var/www/html

echo "[*] Membuat konfigurasi ServerName dan Autoindex..."
cat << 'EOF' > /etc/apache2/conf-available/arsip-autoindex.conf
ServerName vault.k15.com

<Directory /var/www/html/arsip>
    Options Indexes FollowSymLinks
    AllowOverride None
    Require all granted
</Directory>
EOF

echo "[*] Mengaktifkan konfigurasi dan modul Apache..."
a2enconf arsip-autoindex
a2enmod autoindex

echo "[*] Memuat ulang dan memastikan Apache berjalan..."
apache2ctl configtest
service apache2 restart

echo "[+] Setup Area Vault pada node $NODE_NAME selesai!"