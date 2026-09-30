#!/bin/bash

# 1. Install BIND9
apt-get update && apt-get install -y bind9 bind9utils

# 2. Config options
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

# 3. Config Slave Zone k15.com
cat <<EOF > /etc/bind/named.conf.local
zone "k15.com" {
    type slave;
    masters { 10.71.3.2; }; # IP Prab
    file "/var/lib/bind/k15.com";
};
EOF

# 4. Update Resolv.conf di Tedd
cat <<EOF > /etc/resolv.conf
nameserver 10.71.3.2
nameserver 10.71.3.3
nameserver 192.168.122.1
EOF

# 5. Restart Service
service named restart