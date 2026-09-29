#node prab
#!/bin/bash

# Update File Zone /etc/bind/jarkom/k15.com dengan IP presisi gambar
cat <<EOF > /etc/bind/jarkom/k15.com
\$TTL    604800
@       IN      SOA     prab.k15.com. root.k15.com. (
                          2026100105 ; Serial (Naik agar Tedd otomatis sync)
                              604800 ; Refresh
                               86400 ; Retry
                             2419200 ; Expire
                              604800 ) ; Negative Cache TTL
;
@       IN      NS      prab.k15.com.
@       IN      NS      tedd.k15.com.

; Name Server Host (Pengecualian: Tetap sebagai Name Server)
prab    IN      A       10.71.3.2
tedd    IN      A       10.71.3.3

; Apex Domain mengarah ke Penny
@       IN      A       10.71.4.2

; Record A untuk Seluruh Node (Sesuai Gambar Aktual)
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
EOF

# Set Hostname System-Wide di Prab
hostname prab && echo "prab" > /etc/hostname

# Validasi & Restart Service BIND9
named-checkzone k15.com /etc/bind/jarkom/k15.com
service named restart

#node tedd
#!/bin/bash

# Set Hostname System-Wide di Tedd
hostname tedd && echo "tedd" > /etc/hostname

# Restart BIND9 agar sync zone file dari Prab
service named restart

#node client
# Di node rootkit
hostname rootkit && echo "rootkit" > /etc/hostname

# Di node alpha
hostname alpha && echo "alpha" > /etc/hostname

# Di node beta
hostname beta && echo "beta" > /etc/hostname

# Di node gamma
hostname gamma && echo "gamma" > /etc/hostname

# Di node delta
hostname delta && echo "delta" > /etc/hostname

# Di node epsilon
hostname epsilon && echo "epsilon" > /etc/hostname

# Di node abbey
hostname abbey && echo "abbey" > /etc/hostname

# Di node penny
hostname penny && echo "penny" > /etc/hostname

# Di node obladi
hostname obladi && echo "obladi" > /etc/hostname

# Di node desmond
hostname desmond && echo "desmond" > /etc/hostname

# Di node oblada
hostname oblada && echo "oblada" > /etc/hostname

# Di node molly
hostname molly && echo "molly" > /etc/hostname