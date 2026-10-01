#!/bin/sh

# Set Autostart Apache via /etc/rc.local
echo '#!/bin/sh' > /etc/rc.local
echo 'service apache2 start' >> /etc/rc.local
chmod +x /etc/rc.local

# Jalankan service sekarang
service apache2 start

echo "Autostart Apache berhasil diset!"