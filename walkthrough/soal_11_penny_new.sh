#!/bin/bash

# Update dan instalasi paket Apache2
apt-get update && apt-get install -y apache2 curl

# Aktifkan modul proxy, balancer, dan headers
a2enmod proxy proxy_http proxy_balancer lbmethod_byrequests headers

# Buat konfigurasi Reverse Proxy ke Area Vault
cat << 'EOF' > /etc/apache2/sites-available/vault-proxy.conf
<VirtualHost *:80>

    ServerName vault.k15.com

    # Meneruskan identitas asli pengunjung
    ProxyPreserveHost On
    RequestHeader set X-Real-IP "%{REMOTE_ADDR}s"

    # Load balancing ke Obladi dan Desmond
    <Proxy "balancer://vaultcluster">
        BalancerMember http://10.71.3.4:80
        BalancerMember http://10.71.3.5:80
        ProxySet lbmethod=byrequests
    </Proxy>

    ProxyPass / balancer://vaultcluster/
    ProxyPassReverse / balancer://vaultcluster/

</VirtualHost>
EOF

# Aktifkan konfigurasi site baru
a2ensite vault-proxy.conf

# Nonaktifkan default site
a2dissite 000-default.conf

# Cek konfigurasi Apache
apache2ctl configtest

# Jika konfigurasi benar, restart Apache
if [ $? -eq 0 ]; then
    service apache2 restart
    echo "[+] Selesai! Reverse Proxy Apache di Penny aktif."
else
    echo "[-] Konfigurasi Apache masih memiliki error."
    exit 1
fi