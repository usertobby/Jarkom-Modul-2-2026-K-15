#!/bin/bash

# ==========================================================
# SOAL 16 - ApacheBench Stress Test
# Node       : Alpha
# Requests   : 250
# Concurrency: 10
# Endpoint   : www.k15.com & static.k15.com
# ==========================================================

apt-get update
apt-get install -y apache2-utils

mkdir -p ~/soal16

echo "[+] Benchmark www.k15.com..."

ab -n 250 -c 10 http://www.k15.com/ \
    > ~/soal16/hasil_www.txt

echo "[+] Benchmark static.k15.com..."

ab -n 250 -c 10 http://static.k15.com/ \
    > ~/soal16/hasil_static.txt

echo
echo "[+] Benchmark www.k15.com selesai."
echo "[+] Hasil: ~/soal16/hasil_www.txt"

echo
echo "[+] Benchmark static.k15.com selesai."
echo "[+] Hasil: ~/soal16/hasil_static.txt"

echo
echo "=========================================================="
echo " RINGKASAN WWW.K15.COM"
echo "=========================================================="

grep -E \
"Concurrency Level|Time taken for tests|Complete requests|Failed requests|Requests per second|Time per request|Transfer rate" \
~/soal16/hasil_www.txt

echo
echo "=========================================================="
echo " RINGKASAN STATIC.K15.COM"
echo "=========================================================="

grep -E \
"Concurrency Level|Time taken for tests|Complete requests|Failed requests|Requests per second|Time per request|Transfer rate" \
~/soal16/hasil_static.txt

echo
echo "[+] Semua pengujian selesai."