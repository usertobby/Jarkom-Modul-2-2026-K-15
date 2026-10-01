#!/bin/bash

echo "[+] Mengonfigurasi Abbey - /orion..."

apt-get update
apt-get install -y nginx

mkdir -p /var/www/orion

cat << 'EOF' > /var/www/orion/index.html
<!DOCTYPE html>
<html>
<head>
    <title>Orion - Abbey</title>
</head>
<body>
    <h1>Orion - Abbey</h1>
    <p>Halaman ini bersifat statis.</p>
</body>
</html>
EOF

chown -R www-data:www-data /var/www/orion
chmod -R 755 /var/www/orion

cat << 'EOF' > /etc/nginx/sites-available/orion.conf
server {
    listen 80;

    server_name abbey.xxx.com;

    location /orion/ {
        alias /var/www/orion/;
        index index.html;
    }
}
EOF

ln -sf /etc/nginx/sites-available/orion.conf \
/etc/nginx/sites-enabled/orion.conf

nginx -t

if [ $? -ne 0 ]; then
    echo "[-] Konfigurasi Nginx gagal."
    exit 1
fi

service nginx restart

echo "[+] ======================================"
echo "[+] Abbey /orion berhasil dikonfigurasi"
echo "[+] Directory : /var/www/orion"
echo "[+] PHP       : tidak dirender"
echo "[+] ======================================"