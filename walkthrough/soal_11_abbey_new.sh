#!/bin/bash

# Update dan instalasi paket Nginx
apt-get update && apt-get install -y nginx curl

# Buat konfigurasi Reverse Proxy Core
cat << 'EOF' > /etc/nginx/sites-available/core-proxy.conf
upstream core_cluster {
    server 10.71.3.6:80;
    server 10.71.3.7:80;
}

server {
    listen 80;
    server_name core.k15.com abbey.k15.com static.k15.com;

    location / {
        proxy_pass http://core_cluster;

        # Forwarding identitas asli pengunjung
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }
}
EOF

# Aktifkan konfigurasi dan restart Nginx
ln -sf /etc/nginx/sites-available/core-proxy.conf /etc/nginx/sites-enabled/
rm -f /etc/nginx/sites-enabled/default
nginx -t
service nginx restart

echo "[+] Reverse Proxy Nginx di Abbey berhasil dikonfigurasi!"