#!/bin/bash

set -e

echo "[+] Membuat halaman /admin di Desmond..."

mkdir -p /var/www/html/admin

cat << 'EOF' > /var/www/html/admin/index.html
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <title>Vault Admin - Desmond</title>
</head>
<body>
    <h1>Admin Area</h1>
    <p>Backend: Desmond</p>
    <p>Hostname: desmond</p>
</body>
</html>
EOF

chmod -R 755 /var/www/html/admin

echo "[+] Memastikan web server aktif..."

service nginx restart 2>/dev/null || \
service apache2 restart 2>/dev/null || true

echo "[+] /admin Desmond selesai."