#!/bin/bash

echo "[+] Menulis konfigurasi slave reverse zones ke named.conf.local..."
cat <<EOF > /etc/bind/named.conf.local

zone "2.71.10.in-addr.arpa" {
    type slave;
    masters { 10.71.3.2; };
    file "/var/lib/bind/2.71.10.rev";
};

zone "4.71.10.in-addr.arpa" {
    type slave;
    masters { 10.71.3.2; };
    file "/var/lib/bind/4.71.10.rev";
};

zone "3.71.10.in-addr.arpa" {
    type slave;
    masters { 10.71.3.2; };
    file "/var/lib/bind/3.71.10.rev";
};
EOF

echo "[+] Menyalakan ulang / menjalankan BIND9 di tedd..."
killall named 2>/dev/null
/usr/sbin/named

echo "[+] Setup Slave Reverse Zone Selesai!"