#!/bin/bash

echo "[*] Membuat direktori zona jarkom di Prab..."
mkdir -p /etc/bind/jarkom

echo "[*] Mengonfigurasi /etc/bind/named.conf.local..."
cat << 'EOF' > /etc/bind/named.conf.local
zone "k15.com" {
    type master;
    file "/etc/bind/jarkom/k15.com";
    allow-transfer { 10.71.3.3; };
    notify yes;
};

zone "2.71.10.in-addr.arpa" {
    type master;
    file "/etc/bind/jarkom/2.71.10.rev";
    allow-transfer { 10.71.3.3; };
    notify yes;
};

zone "4.71.10.in-addr.arpa" {
    type master;
    file "/etc/bind/jarkom/4.71.10.rev";
    allow-transfer { 10.71.3.3; };
    notify yes;
};

zone "3.71.10.in-addr.arpa" {
    type master;
    file "/etc/bind/jarkom/3.71.10.rev";
    allow-transfer { 10.71.3.3; };
    notify yes;
};
EOF

echo "[*] Membuat database zona Reverse Abbey (2.71.10.rev)..."
cat << 'EOF' > /etc/bind/jarkom/2.71.10.rev
$TTL    604800
@       IN      SOA     prab.k15.com. root.k15.com. (
                          2026100108 ; Serial
                              604800 ; Refresh
                               86400 ; Retry
                             2419200 ; Expire
                              604800 ) ; Negative Cache TTL
;
@       IN      NS      prab.k15.com.
@       IN      NS      tedd.k15.com.

2       IN      PTR     abbey.k15.com.
EOF

echo "[*] Membuat database zona Reverse Penny (4.71.10.rev)..."
cat << 'EOF' > /etc/bind/jarkom/4.71.10.rev
$TTL    604800
@       IN      SOA     prab.k15.com. root.k15.com. (
                          2026100108 ; Serial
                              604800 ; Refresh
                               86400 ; Retry
                             2419200 ; Expire
                              604800 ) ; Negative Cache TTL
;
@       IN      NS      prab.k15.com.
@       IN      NS      tedd.k15.com.

2       IN      PTR     penny.k15.com.
EOF

echo "[*] Membuat database zona Reverse Vault & Core (3.71.10.rev)..."
cat << 'EOF' > /etc/bind/jarkom/3.71.10.rev
$TTL    604800
@       IN      SOA     prab.k15.com. root.k15.com. (
                          2026100108 ; Serial
                              604800 ; Refresh
                               86400 ; Retry
                             2419200 ; Expire
                              604800 ) ; Negative Cache TTL
;
@       IN      NS      prab.k15.com.
@       IN      NS      tedd.k15.com.

2       IN      PTR     prab.k15.com.
3       IN      PTR     tedd.k15.com.
4       IN      PTR     obladi.k15.com.
5       IN      PTR     desmond.k15.com.
6       IN      PTR     oblada.k15.com.
7       IN      PTR     molly.k15.com.
EOF

echo "[*] Memeriksa sintaks seluruh file konfigurasi zona..."
named-checkzone 2.71.10.in-addr.arpa /etc/bind/jarkom/2.71.10.rev
named-checkzone 4.71.10.in-addr.arpa /etc/bind/jarkom/4.71.10.rev
named-checkzone 3.71.10.in-addr.arpa /etc/bind/jarkom/3.71.10.rev

echo "[*] Memuat ulang service BIND9 di Prab..."
service named restart || /usr/sbin/named
echo "[+] Setup Master Reverse DNS Prab selesai."