# Jarkom-Modul-2-2026-K-15


| Nama | NRP |
| ---  | --- |
| I Made Tobby Anantha Adiwijaya | 5027251064 |
| Rheza Pramudita Adi Putra | 5027251090 |

## Soal 1
Sebagai pusat kesadaran The Mesh, rootkit harus merentangkan koneksinya ke lima gerbang utama (Switch). Kita tetapkan alamat IP dan default gateway untuk seluruh entitas, mulai dari para operator (**alpha, beta, gamma**), penjaga directory (**prab, tedd**), gerbang penyaring (**abbey, penny**), hingga repository (**obladi, desmond, oblada, molly**).
![image](/assets/soal_1/topologi.png)

## Soal 2
Pada soal ini kita memastikan agar semua host di dalam jaringan dapat menjangkau internet publik menggunakan IP address. Dengan cara membuka jalur menuju NAT dengan memastikan antarmuka WAN di router rootkit aktif. Konfigurasikan pada node `rootkit` dengan menggunakan:
```
up sysctl -w net.ipv4.ip_forward=1
up iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
```

## Soal 3
Untuk menghindari fragmentasi saat persiapan, kita pastikan setiap host non-router menambahkan `resolver 192.168.122.1` pada setiap node tersebut. Konfigurasi yang digunakan ialah:
```
up echo "nameserver 192.168.122.1" > /etc/resolv.conf
```

## Soal 4