#!/bin/bash

# Pastikan dijalankan sebagai root
if [ "$EUID" -ne 0 ]; then
  echo "Harap jalankan skrip ini sebagai root!"
  exit 1
fi

echo "[+] 1. Mempersiapkan direktori web root..."
mkdir -p /var/www/html/core
chown -R www-data:www-data /var/www/html/core

echo "[+] 2. Membuat file aplikasi index.php..."
cat << 'EOF' > /var/www/html/core/index.php
<!DOCTYPE html>
<html>
<head><title>Beranda - Core</title></head>
<body>
    <h1>Selamat Datang di Halaman Beranda Core</h1>
    <p><a href="/profil">Ke Halaman Profil</a></p>
</body>
</html>
EOF

echo "[+] 3. Membuat file aplikasi profil.php..."
cat << 'EOF' > /var/www/html/core/profil.php
<!DOCTYPE html>
<html>
<head><title>Profil - Core</title></head>
<body>
    <h1>Halaman Profil Pengguna</h1>
    <p>Ini adalah halaman profil dengan URL bersih (Clean URL).</p>
    <p><a href="/">Kembali ke Beranda</a></p>
</body>
</html>
EOF

echo "[+] 4. Membuat konfigurasi Virtual Host Nginx..."
cat << 'EOF' > /etc/nginx/sites-available/core.conf
server {
    listen 80;
    server_name core.k15.com;

    root /var/www/html/core;
    index index.php index.html index.htm;

    location / {
        try_files $uri $uri/ @extensionless;
    }

    location @extensionless {
        rewrite ^(.*)$ /$1.php last;
    }

    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/var/run/php/php8.4-fpm.sock;
    }
}
EOF

echo "[+] 5. Mengaktifkan konfigurasi Nginx dan symlink..."
ln -sf /etc/nginx/sites-available/core.conf /etc/nginx/sites-enabled/
rm -f /etc/nginx/sites-enabled/default

echo "[+] 6. Menjalankan ulang layanan PHP-FPM dan Nginx..."
systemctl restart php8.4-fpm
nginx -t && systemctl restart nginx

echo "[+] Konfigurasi selesai! Silakan uji menggunakan curl http://core.k15.com/ dan curl http://core.k15.com/profil"