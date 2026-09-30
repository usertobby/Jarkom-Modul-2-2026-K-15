#!/bin/bash

cat << 'EOF' > /etc/bind/jarkom/k15.com
$TTL    604800
@       IN      SOA     prab.k15.com. root.k15.com. (
                          2026100107 ; Serial dinaikkan untuk sync ke Tedd
                              604800 ; Refresh
                               86400 ; Retry
                             2419200 ; Expire
                              604800 ) ; Negative Cache TTL
;
; Name Servers
@       IN      NS      prab.k15.com.
@       IN      NS      tedd.k15.com.

; A Record untuk Name Server
prab    IN      A       10.71.3.2
tedd    IN      A       10.71.3.3

; Apex Domain (@) mengarah ke Penny
@       IN      A       10.71.4.2

; A Record Node Utama
rootkit IN      A       192.168.122.59
alpha   IN      A       10.71.1.2
beta    IN      A       10.71.1.3
gamma   IN      A       10.71.1.4
delta   IN      A       10.71.5.2
epsilon IN      A       10.71.5.3
abbey   IN      A       10.71.2.2
penny   IN      A       10.71.4.2
obladi  IN      A       10.71.3.4
desmond IN      A       10.71.3.5
oblada  IN      A       10.71.3.6
molly   IN      A       10.71.3.7

; Soal 7: A Record vault (obladi & desmond) - DNS Round Robin
vault   IN      A       10.71.3.4
vault   IN      A       10.71.3.5

; Soal 7: A Record core (oblada & molly) - DNS Round Robin
core    IN      A       10.71.3.6
core    IN      A       10.71.3.7

; Soal 7: CNAME Records
www     IN      CNAME   penny.k15.com.
static  IN      CNAME   abbey.k15.com.
EOF

echo "[*] Memeriksa sintaks zona..."
named-checkzone k15.com /etc/bind/jarkom/k15.com

echo "[*] Me-restart BIND9 Master..."
service named restart