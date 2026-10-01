#!/bin/bash

# Soal 13 - Redirect Penny
# 10.71.4.2 / penny.k15.com -> 301 -> www.k15.com

cat << 'EOF' > /etc/apache2/sites-available/penny-redirect.conf
<VirtualHost *:80>
    ServerName 10.71.4.2
    ServerAlias penny.k15.com

    Redirect permanent / http://www.k15.com/
</VirtualHost>
EOF

a2enmod alias
a2ensite penny-redirect.conf

apache2ctl configtest

if [ $? -ne 0 ]; then
    echo "[-] Konfigurasi Apache gagal."
    exit 1
fi

service apache2 restart

echo "[+] Redirect Penny berhasil dikonfigurasi."
echo "[+] penny.k15.com / 10.71.4.2 -> 301 -> www.k15.com"