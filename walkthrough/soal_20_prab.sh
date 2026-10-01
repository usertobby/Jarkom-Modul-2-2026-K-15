#!/bin/sh

# 1. Kembalikan IP Abbey ke 10.71.2.2 pada file zona
sed -i 's/abbey\s*IN\s*A\s*[0-9.]*/abbey    IN  A   10.71.2.2/g' /etc/bind/jarkom/k15.com

# 2. Naikkan serial SOA otomatis
current_serial=$(grep -o '[0-9]\{10\}' /etc/bind/jarkom/k15.com | head -n 1)
new_serial=$((current_serial + 1))
sed -i "s/$current_serial/$new_serial/" /etc/bind/jarkom/k15.com

# 3. Validasi dan Restart BIND9
named-checkzone k15.com /etc/bind/jarkom/k15.com
service bind9 restart

# 4. Set Autostart via /etc/rc.local
echo '#!/bin/sh' > /etc/rc.local
echo 'service bind9 start' >> /etc/rc.local
chmod +x /etc/rc.local

echo "Konfigurasi Prab selesai!"