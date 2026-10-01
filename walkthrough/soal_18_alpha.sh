#!/bin/bash

DOMAIN="abbey.k15.com"

echo "=========================================="
echo " FASE 1: Query Awal (Menyimpan ke Cache)"
echo "=========================================="
dig +noall +answer "$DOMAIN"
echo ""

echo "=========================================="
echo " FASE 2: Query Cepat (< 15 Detik)"
echo "=========================================="
echo "Melakukan query saat masa cache belum habis..."
dig +noall +answer "$DOMAIN"
echo ""

echo "=========================================="
echo " FASE 3: Menunggu TTL Kedaluwarsa (> 15 Detik)"
echo "=========================================="
echo "Menunggu selama 15 detik agar cache expired..."
sleep 15
echo "Melakukan query ulang..."
dig +noall +answer "$DOMAIN"
echo ""
echo "=== Pengujian 3 Fase Selesai ==="