#!/bin/bash

set -e

echo "[+] Menginstall apache2-utils..."
apt-get update
apt-get install -y apache2-utils

# ----------------------------------------------------------
# 1. Membuat file username/password
# ----------------------------------------------------------

echo "[+] Membuat user Basic Authentication: prabs"

htpasswd -cb /etc/apache2/.htpasswd \
    prabs 'pakar_pinter_jadi_gob***'

# Amankan file password
chown root:www-data /etc/apache2/.htpasswd
chmod 640 /etc/apache2/.htpasswd

# ----------------------------------------------------------
# 2. Membuat konfigurasi Apache
# ----------------------------------------------------------

echo "[+] Membuat konfigurasi vault-proxy.conf..."

cat << 'EOF' > /etc/apache2/sites-available/vault-proxy.conf
<VirtualHost *:80>

    ServerName vault.k15.com

    # Meneruskan identitas asli pengunjung
    ProxyPreserveHost On
    RequestHeader set X-Real-IP "%{REMOTE_ADDR}s"

    # Load balancing ke Area Vault
    <Proxy "balancer://vaultcluster">
        BalancerMember http://10.71.3.4:80
        BalancerMember http://10.71.3.5:80
        ProxySet lbmethod=byrequests
    </Proxy>

    # Reverse Proxy
    ProxyPass / balancer://vaultcluster/
    ProxyPassReverse / balancer://vaultcluster/

    # Basic Authentication untuk /admin
    <Location "/admin">
        AuthType Basic
        AuthName "Area Rahasia Sindikat"
        AuthUserFile /etc/apache2/.htpasswd
        Require valid-user
    </Location>

</VirtualHost>
EOF

# ----------------------------------------------------------
# 3. Aktifkan module yang diperlukan
# ----------------------------------------------------------

echo "[+] Mengaktifkan modul Apache..."

a2enmod proxy
a2enmod proxy_http
a2enmod proxy_balancer
a2enmod lbmethod_byrequests
a2enmod headers
a2enmod auth_basic
a2enmod authn_file

# ----------------------------------------------------------
# 4. Aktifkan site
# ----------------------------------------------------------

echo "[+] Mengaktifkan vault-proxy.conf..."

a2ensite vault-proxy.conf

# Nonaktifkan default site jika ada
a2dissite 000-default.conf 2>/dev/null || true

# ----------------------------------------------------------
# 5. Cek konfigurasi sebelum restart
# ----------------------------------------------------------

echo "[+] Mengecek konfigurasi Apache..."

apache2ctl configtest

# ----------------------------------------------------------
# 6. Restart Apache
# ----------------------------------------------------------

echo "[+] Restart Apache..."

service apache2 restart

echo
echo "[+] ============================================"
echo "[+] SOAL 12 SELESAI"
echo "[+] ============================================"
echo "[+] Basic Authentication aktif pada /admin"
echo "[+] Username : prabs"
echo "[+] Backend  : 10.71.3.4 dan 10.71.3.5"
echo "[+] ============================================"