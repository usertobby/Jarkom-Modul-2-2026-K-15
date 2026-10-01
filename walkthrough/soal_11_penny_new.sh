#!/bin/bash

# Update dan instalasi paket Apache2
apt-get update && apt-get install -y apache2 curl

# Aktifkan seluruh modul proxy, balancer, dan headers yang dibutuhkan
a2enmod proxy proxy_http proxy_balancer lbmethod_byrequests headers

# Buat konfigurasi Reverse Proxy ke Area Vault (Obladi & Desmond)
cat << 'EOF' > /etc/apache2/sites-available/vault-proxy.conf

    ServerName vault.k15.com

    # Meneruskan identitas asli pengunjung (Host & X-Real-IP)
    ProxyPreserveHost On
    RequestHeader set X-Real-IP "%{REMOTE_ADDR}s"

    # Load balancing ke Obladi (10.71.3.4) dan Desmond (10.71.3.5)
    
        BalancerMember http://10.71.3.4:80
        BalancerMember http://10.71.3.5:80
        ProxySet lbmethod=byrequests
    

    ProxyPass / balancer://vaultcluster/
    ProxyPassReverse / balancer://vaultcluster/

EOF

# Aktifkan konfigurasi site baru dan nonaktifkan default site
a2ensite vault-proxy.conf
a2dissite 000-default.conf

# Cek sintaks dan restart layanan Apache2
apache2ctl configtest && service apache2 restart

echo "[+] Selesai! Reverse Proxy Apache di Penny aktif tanpa error."