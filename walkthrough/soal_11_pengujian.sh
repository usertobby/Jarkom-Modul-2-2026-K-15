# Tambahkan mapping domain ke hosts (jika belum)
echo "10.71.4.2 vault.k15.com" >> /etc/hosts
echo "127.0.0.1 core.k15.com" >> /etc/hosts

# Jalankan pengujian request
curl -I http://vault.k15.com/
curl -I http://core.k15.com/