#!/bin/sh

# Set Autostart Nginx & PHP-FPM via /etc/rc.local
echo '#!/bin/sh' > /etc/rc.local
echo 'service nginx start' >> /etc/rc.local
echo 'service php8.4-fpm start' >> /etc/rc.local
chmod +x /etc/rc.local

# Jalankan service sekarang
service nginx start
service php8.4-fpm start

echo "Autostart Nginx & PHP-FPM berhasil diset!"