#!/bin/bash

echo "[+] Membuat direktori zona jika belum ada..."
mkdir -p /etc/bind/jarkom

echo "[+] Menulis konfigurasi master reverse zones ke named.conf.local..."
cat <<EOF > /etc/bind/named.conf.local

zone "2.71.10.in-addr.arpa" {
    type master;
    file "/etc/bind/jarkom/2.71.10.rev";
    allow-transfer { 10.71.3.3; };
};

zone "4.71.10.in-addr.arpa" {
    type master;
    file "/etc/bind/jarkom/4.71.10.rev";
    allow-transfer { 10.71.3.3; };
};

zone "3.71.10.in-addr.arpa" {
    type master;
    file "/etc/bind/jarkom/3.71.10.rev";
    allow-transfer { 10.71.3.3; };
};
EOF

echo "[+] Membuat file reverse zone untuk subnet 10.71.2.x (abbey)..."
cat <<EOF > /etc/bind/jarkom/2.71.10.rev
\$TTL    604800
@       IN      SOA     prab.k15.com. root.k15.com. (
                          2026100101 ; Serial
                              604800 ; Refresh
                               86400 ; Retry
                             2419200 ; Expire
                              604800 ) ; Negative Cache TTL
;
@       IN      NS      prab.k15.com.
@       IN      NS      tedd.k15.com.

2       IN      PTR     abbey.k15.com.
EOF

echo "[+] Membuat file reverse zone untuk subnet 10.71.4.x (penny)..."
cat <<EOF > /etc/bind/jarkom/4.71.10.rev
\$TTL    604800
@       IN      SOA     prab.k15.com. root.k15.com. (
                          2026100101 ; Serial
                              604800 ; Refresh
                               86400 ; Retry
                             2419200 ; Expire
                              604800 ) ; Negative Cache TTL
;
@       IN      NS      prab.k15.com.
@       IN      NS      tedd.k15.com.

2       IN      PTR     penny.k15.com.
EOF

echo "[+] Membuat file reverse zone untuk subnet 10.71.3.x (vault, core, dll)..."
cat <<EOF > /etc/bind/jarkom/3.71.10.rev
\$TTL    604800
@       IN      SOA     prab.k15.com. root.k15.com. (
                          2026100101 ; Serial
                              604800 ; Refresh
                               86400 ; Retry
                             2419200 ; Expire
                              604800 ) ; Negative Cache TTL
;
@       IN      NS      prab.k15.com.
@       IN      NS      tedd.k15.com.

2       IN      PTR     prab.k15.com.
3       IN      PTR     tedd.k15.com.
4       IN      PTR     vault.k15.com.
5       IN      PTR     vault.k15.com.
6       IN      PTR     core.k15.com.
7       IN      PTR     core.k15.com.
EOF

echo "[+] Menyalakan ulang / menjalankan BIND9 di prab..."
killall named 2>/dev/null
/usr/sbin/named

echo "[+] Setup Master Reverse Zone Selesai!"