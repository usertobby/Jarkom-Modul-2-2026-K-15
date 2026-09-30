#!/bin/bash

echo "[*] Memeriksa file zone k15.com di Prab..."
named-checkzone k15.com /etc/bind/jarkom/k15.com

echo "[*] Merestart BIND9 Master untuk memicu NOTIFY ke Slave..."
service named restart

echo "[*] Nomor Serial SOA saat ini di Prab:"
dig @10.71.3.2 k15.com SOA +short
