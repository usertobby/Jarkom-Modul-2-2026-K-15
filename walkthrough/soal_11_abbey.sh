cat << 'EOF' > /etc/nginx/sites-available/core-proxy.conf
upstream core_cluster {
    server 10.71.3.6;
    server 10.71.3.7;
}

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

ln -s /etc/nginx/sites-available/core-proxy.conf /etc/nginx/sites-enabled/
rm -f /etc/nginx/sites-enabled/default
nginx -t
service nginx restart