#node prab
#!/bin/bash

echo "[*] Memeriksa file zone k15.com di Prab..."
named-checkzone k15.com /etc/bind/jarkom/k15.com

echo "[*] Merestart BIND9 Master untuk memicu NOTIFY ke Slave..."
service named restart

echo "[*] Nomor Serial SOA saat ini di Prab:"
dig @10.71.3.2 k15.com SOA +short

#node tedd
#!/bin/bash

echo "[*] Menyiapkan direktori penampung zone transfer..."
mkdir -p /var/lib/bind
chown -R bind:bind /var/lib/bind
chmod 755 /var/lib/bind

echo "[*] Memastikan konfigurasi slave k15.com terpasang..."
cat <<EOF > /etc/bind/named.conf.local
zone "k15.com" {
    type slave;
    masters { 10.71.3.2; };
    file "/var/lib/bind/k15.com";
};
EOF

echo "[*] Merestart BIND9 Slave untuk menarik Zone Transfer..."
service named restart

echo "[*] Mengecek apakah file salinan zona sudah ada:"
ls -l /var/lib/bind/k15.com

echo "[*] Nomor Serial SOA pada Slave (Tedd):"
dig @10.71.3.3 k15.com SOA +short