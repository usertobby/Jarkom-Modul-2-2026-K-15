#!/bin/bash

echo "[*] Memastikan paket bind9 dan utilitas terpasang..."
apt-get update && apt-get install -y bind9 bind9utils dnsutils

echo "[*] Menyiapkan direktori penyimpanan transfer zona slave..."
mkdir -p /var/lib/bind
chown -R bind:bind /var/lib/bind
chmod 775 /var/lib/bind

echo "[*] Mengonfigurasi Slave Zones di /etc/bind/named.conf.local..."
cat << 'EOF' > /etc/bind/named.conf.local
zone "k15.com" {
    type slave;
    masters { 10.71.3.2; };
    file "/var/lib/bind/k15.com";
    masterfile-format text;
};

zone "2.71.10.in-addr.arpa" {
    type slave;
    masters { 10.71.3.2; };
    file "/var/lib/bind/2.71.10.rev";
    masterfile-format text;
};

zone "4.71.10.in-addr.arpa" {
    type slave;
    masters { 10.71.3.2; };
    file "/var/lib/bind/4.71.10.rev";
    masterfile-format text;
};

zone "3.71.10.in-addr.arpa" {
    type slave;
    masters { 10.71.3.2; };
    file "/var/lib/bind/3.71.10.rev";
    masterfile-format text;
};
EOF

echo "[*] Memuat ulang service BIND9 di Tedd..."
service named restart || /usr/sbin/named

echo "[*] Menunggu proses Zone Transfer sinkron (3 detik)..."
sleep 3

echo "[*] Daftar file zona yang berhasil ditarik oleh Tedd:"
ls -lh /var/lib/bind/
echo "[+] Setup Slave Reverse DNS Tedd selesai."