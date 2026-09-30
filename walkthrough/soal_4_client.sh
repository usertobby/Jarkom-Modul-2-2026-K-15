#!/bin/bash

cat <<EOF > /etc/resolv.conf
nameserver 10.71.3.2
nameserver 10.71.3.3
nameserver 192.168.122.1
EOF