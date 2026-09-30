#!/bin/bash

# 1. Install BIND9
apt-get update && apt-get install -y bind9 bind9utils

# 2. Buat folder zone jarkom
mkdir -p /etc/bind/jarkom

# 3. Config options (Forwarders ke IP NAT)
cat <<EOF > /etc/bind/named.conf.options
options {
    directory "/var/cache/bind";

    forwarders {
        192.168.122.1;
    };

    allow-query { any; };
    auth-nxdomain no;
    listen-on-v6 { any; };
};
EOF

# 4. Config Master Zone k15.com
cat <<EOF > /etc/bind/named.conf.local
zone "k15.com" {
    type master;
    file "/etc/bind/jarkom/k15.com";
    allow-transfer { 10.71.3.3; }; # IP Tedd
    notify yes;
};
EOF

# 5. File Zone Database k15.com (Khusus Soal 4)
cat <<EOF > /etc/bind/jarkom/k15.com
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

; Name Servers A Record
prab    IN      A       10.71.3.2
tedd    IN      A       10.71.3.3

; Apex Domain (@) mengarah ke Penny
@       IN      A       10.71.4.2
EOF

# 6. Update Resolv.conf di Prab
cat <<EOF > /etc/resolv.conf
nameserver 10.71.3.2
nameserver 10.71.3.3
nameserver 192.168.122.1
EOF

# 7. Check Syntax & Restart Service
named-checkzone k15.com /etc/bind/jarkom/k15.com
service named restart