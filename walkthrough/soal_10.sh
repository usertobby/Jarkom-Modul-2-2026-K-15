#!/bin/bash

# Update dan instalasi paket
apt-get update
apt-get install -y nginx php-fpm curl

# Deteksi service PHP-FPM dan jalankan
PHP_SERVICE=$(ls /etc/init.d/ | grep -E "php.*fpm" | head -n 1)

if [ -z "$PHP_SERVICE" ]; then
    echo "[-] PHP-FPM tidak ditemukan."
    exit 1
fi

service "$PHP_SERVICE" start

# Deteksi socket PHP-FPM
PHP_SOCK=$(find /run/php/ -name "php*-fpm.sock" 2>/dev/null | head -n 1)

if [ -z "$PHP_SOCK" ]; then
    echo "[-] Socket PHP-FPM tidak ditemukan."
    exit 1
fi

echo "[+] PHP-FPM service : $PHP_SERVICE"
echo "[+] PHP-FPM socket  : $PHP_SOCK"

# Buat direktori web
mkdir -p /var/www/html/core

# Buat berkas index.php
cat << 'EOF' > /var/www/html/core/index.php
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Beranda - Core</title>
</head>
<body>
    <h1>Selamat Datang di Halaman Beranda Core</h1>
    <p>
        <strong>Server Hostname:</strong>
        <?php echo htmlspecialchars(gethostname()); ?>
    </p>
    <a href="/profil">Ke Halaman Profil</a>
</body>
</html>
EOF

# Buat berkas profil.php
cat << 'EOF' > /var/www/html/core/profil.php
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Profil - Core</title>
</head>
<body>
    <h1>Halaman Profil Pengguna</h1>
    <p>
        Ini adalah halaman profil dengan URL bersih (Clean URL).
    </p>
    <p>
        <strong>Server Hostname:</strong>
        <?php echo htmlspecialchars(gethostname()); ?>
    </p>
    <p>
        <strong>Waktu Server:</strong>
        <?php echo date('Y-m-d H:i:s'); ?>
    </p>
    <a href="/">Kembali ke Beranda</a>
</body>
</html>
EOF

# Atur hak akses
chown -R www-data:www-data /var/www/html/core
chmod -R 755 /var/www/html/core

# Buat konfigurasi virtual host Nginx
cat << EOF > /etc/nginx/sites-available/core.conf
server {
    listen 80;
    server_name core.k15.com oblada.k15.com molly.k15.com;

    root /var/www/html/core;
    index index.php index.html index.htm;

    location / {
        try_files \$uri \$uri/ @cleanurl;
    }

    location @cleanurl {
        rewrite ^/([^.]*)$ /\$1.php last;
    }

    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:$PHP_SOCK;
    }
}
EOF

# Aktifkan konfigurasi
ln -sf /etc/nginx/sites-available/core.conf /etc/nginx/sites-enabled/core.conf
rm -f /etc/nginx/sites-enabled/default

# Tes konfigurasi Nginx
nginx -t

if [ $? -ne 0 ]; then
    echo "[-] Konfigurasi Nginx gagal."
    exit 1
fi

# Restart service
service "$PHP_SERVICE" restart
service nginx restart

echo "[+] Selesai! Node $(hostname) berhasil dikonfigurasi."