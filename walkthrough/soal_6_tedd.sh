#!/bin/bash

echo "[*] Menyiapkan direktori penampung zone transfer..."
mkdir -p /var/lib/bind
chown -R bind:bind /var/lib/bind
chmod 775 /var/lib/bind

echo "[*] Mengonfigurasi slave k15.com di /etc/bind/named.conf.local..."
cat << 'EOF' > /etc/bind/named.conf.local
zone "k15.com" {
    type slave;
    masters { 10.71.3.2; };
    file "/var/lib/bind/k15.com";
    masterfile-format text;
};
EOF

echo "[*] Merestart BIND9 Slave..."
service named restart

echo "[*] Menunggu proses Zone Transfer (3 detik)..."
sleep 3

echo "[*] Mengecek keberadaan file zona salinan:"
ls -lh /var/lib/bind/k15.com

echo "[*] Nomor Serial SOA pada Slave (Tedd):"
dig @10.71.3.3 k15.com SOA +short