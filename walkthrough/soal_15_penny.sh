#!/bin/bash

echo "[+] Mengonfigurasi Penny - /eternal..."

# Install Apache, PHP-FPM, dan modul yang dibutuhkan
apt-get update
apt-get install -y apache2 php-fpm

# ----------------------------------------------------------
# Cari service PHP-FPM
# ----------------------------------------------------------

PHP_SERVICE=$(ls /etc/init.d/ 2>/dev/null | grep -E '^php[0-9.]+-fpm$' | head -n 1)

if [ -z "$PHP_SERVICE" ]; then
    echo "[-] Service PHP-FPM tidak ditemukan."
    echo "[-] Cek instalasi PHP-FPM dengan:"
    echo "    dpkg -l | grep php | grep fpm"
    exit 1
fi

echo "[+] PHP-FPM service ditemukan: $PHP_SERVICE"

# Jalankan PHP-FPM
service "$PHP_SERVICE" start

# ----------------------------------------------------------
# Cari socket PHP-FPM
# ----------------------------------------------------------

PHP_SOCK=$(find /run/php /var/run/php -type s \
    -name "php*-fpm.sock" 2>/dev/null | head -n 1)

if [ -z "$PHP_SOCK" ]; then
    echo "[-] Socket PHP-FPM tidak ditemukan."
    echo "[-] Service yang digunakan: $PHP_SERVICE"
    echo "[-] Status service:"
    service "$PHP_SERVICE" status
    exit 1
fi

echo "[+] PHP-FPM socket ditemukan: $PHP_SOCK"

# ----------------------------------------------------------
# Buat directory Eternal
# ----------------------------------------------------------

mkdir -p /var/www/eternal

# ----------------------------------------------------------
# Buat halaman PHP
# ----------------------------------------------------------

cat << 'EOF' > /var/www/eternal/index.php
<?php
echo "<h1>Eternal - Penny</h1>";
echo "<p>PHP berhasil dirender.</p>";
echo "<p>Hostname: " . gethostname() . "</p>";
?>
EOF

# Permission
chown -R www-data:www-data /var/www/eternal
chmod -R 755 /var/www/eternal

# ----------------------------------------------------------
# Buat konfigurasi Apache
# ----------------------------------------------------------

cat << EOF > /etc/apache2/sites-available/eternal.conf
<VirtualHost *:80>

    ServerName penny.xxx.com

    Alias /eternal/ /var/www/eternal/

    <Directory /var/www/eternal>
        Options -Indexes
        AllowOverride None
        Require all granted
        DirectoryIndex index.php index.html
    </Directory>

    <FilesMatch "\.php$">
        SetHandler "proxy:unix:$PHP_SOCK|fcgi://localhost/"
    </FilesMatch>

</VirtualHost>
EOF

# ----------------------------------------------------------
# Aktifkan module Apache
# ----------------------------------------------------------

a2enmod proxy
a2enmod proxy_fcgi

# Aktifkan site
a2ensite eternal.conf

# ----------------------------------------------------------
# Test konfigurasi
# ----------------------------------------------------------

echo "[+] Mengecek konfigurasi Apache..."

apache2ctl configtest

if [ $? -ne 0 ]; then
    echo "[-] Konfigurasi Apache gagal."
    exit 1
fi

# ----------------------------------------------------------
# Restart Apache
# ----------------------------------------------------------

service apache2 restart

echo
echo "[+] ======================================"
echo "[+] Penny /eternal berhasil dikonfigurasi"
echo "[+] Directory : /var/www/eternal"
echo "[+] PHP       : aktif"
echo "[+] Socket    : $PHP_SOCK"
echo "[+] ======================================"