#!/bin/bash

# Soal 13 - Redirect Abbey
# abbey.k15.com / 10.71.2.2 -> 302 -> static.k15.com

cat << 'EOF' > /etc/nginx/sites-available/core-proxy.conf
upstream core_cluster {
    server 10.71.3.6:80;
    server 10.71.3.7:80;
}

# Redirect Abbey
server {
    listen 80;
    server_name abbey.k15.com 10.71.2.2;

    return 302 http://static.k15.com$request_uri;
}

# Reverse Proxy Core
server {
    listen 80;
    server_name core.k15.com;

    location / {
        proxy_pass http://core_cluster;

        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }
}
EOF

nginx -t

if [ $? -ne 0 ]; then
    echo "[-] Konfigurasi Nginx gagal."
    exit 1
fi

service nginx restart

echo "[+] Redirect Abbey berhasil dikonfigurasi."
echo "[+] abbey.k15.com / 10.71.2.2 -> 302 -> static.k15.com"