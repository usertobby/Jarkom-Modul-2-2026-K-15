# Jarkom-Modul-2-2026-K-15


| Nama | NRP |
| ---  | --- |
| I Made Tobby Anantha Adiwijaya | 5027251064 |
| Rheza Pramudita Adi Putra | 5027251090 |

## Soal 1
Sebagai pusat kesadaran The Mesh, rootkit harus merentangkan koneksinya ke lima gerbang utama (Switch). Kita tetapkan alamat IP dan default gateway untuk seluruh entitas, mulai dari para operator (**alpha, beta, gamma**), penjaga directory (**prab, tedd**), gerbang penyaring (**abbey, penny**), hingga repository (**obladi, desmond, oblada, molly**).
![image](/assets/topologi.png)

Uji coba ping gateway lokal router:
```
ping -c 3 10.71.1.1
```

## Soal 2
Pada soal ini kita memastikan agar semua host di dalam jaringan dapat menjangkau internet publik menggunakan IP address. Dengan cara membuka jalur menuju NAT dengan memastikan antarmuka WAN di router rootkit aktif. Konfigurasikan pada node `rootkit` dengan menggunakan:
```
up sysctl -w net.ipv4.ip_forward=1
up iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
```

Uji coba ping internet dengan menggunakan:
```
ping -c 3 8.8.8.8

ping -c 3 google.com
```

## Soal 3
Untuk menghindari fragmentasi saat persiapan, kita pastikan setiap host non-router menambahkan `resolver 192.168.122.1` pada setiap node tersebut. Konfigurasi yang digunakan ialah:
```
up echo "nameserver 192.168.122.1" > /etc/resolv.conf
```

Cara mengeceknya gunakan beberapa command ini di terminal node tersebut.
```
cat /etc/resolv.conf
# atau
nslookup google.com
```

## Soal 4
Soal kali ini adalah membuat sistem "Buku Telepon" internal (DNS Server) untuk jaringan The Mesh agar semua entitas bisa berkomunikasi menggunakan nama domain seperti `xxxx.com`, tidak lagi hanya bergantung pada IP Address.

Langkah pertama adalah set DNS Master di Node `prab`. Buka terminal di Node `prab` lalu pertama
```
apt-get update && apt-get install -y bind9 bind9utils
```
setelah selesai, edit file `/etc/bind/named.conf.options`
```
nano /etc/bind/named.conf.options
```
sesuaikan menjadi
```
options {
    directory "/var/cache/bind";

    forwarders {
        192.168.122.1;
    };

    allow-query { any; };
    auth-nxdomain no;
    listen-on-v6 { any; };
};
```
lalu `CTRL + O` untuk simpan dan `CTRL + X` untuk keluar. Setelah itu deklarasikan Master Zone di `/etc/bind/named.conf.local`
```
zone "<xxxx>.com" {
    type master;
    file "/etc/bind/jarkom/<xxxx>.com";
    allow-transfer { <IP_TEDD>; };
    notify yes;
};
```
ganti `<xxxx>`.com dengan nama kelompok dan `<IP_TEDD>` dengan IP milik node tedd. Setelah itu buat file database DNS Record, Buka file database zone baru di `prab`
```
mkdir -p /etc/bind/jarkom
nano /etc/bind/jarkom/<xxxx>.com
```
isi dengan kode berikut, ganti `<xxxx>`.com dengan nama kelompok, dan masukkan IP asli `prab`, `tedd`, dan `penny`
```
$TTL    604800
@       IN      SOA     prab.<xxxx>.com. root.<xxxx>.com. (
                          2026100101 ; Serial
                              604800 ; Refresh
                               86400 ; Retry
                             2419200 ; Expire
                              604800 ) ; Negative Cache TTL
;
; Record NS (Name Server)
@       IN      NS      prab.<xxxx>.com.
@       IN      NS      tedd.<xxxx>.com.

; Record A untuk Host
prab    IN      A       <IP_PRAB>
tedd    IN      A       <IP_TEDD>

; Record A Apex domain (@) mengarah ke penny
@       IN      A       <IP_PENNY>
```
simpan lalu keluar, lalu restart `BIND9` di prab
```
service bind9 restart
```
atau
```
service named restart
```
Selanjutnya pindah ke node `tedd`, install BIND9
```
apt-get update && apt-get install -y bind9 bind9utils
```
Edit file `/etc/bind/named.conf.options`
```
nano /etc/bind/named.conf.options
```
Atur isinya di bagian forwarders ke IP `NAT`
```
options {
    directory "/var/cache/bind";

    forwarders {
        192.168.122.1;
    };

    allow-query { any; };
};
```
simpan lalu keluar, lalu deklarasikan Slave Zone di `/etc/bind/named.conf.local`
```
nano /etc/bind/named.conf.local
```
Tambahkan blok zone slave ini di baris paling bawah
```
zone "<xxxx>.com" {
    type slave;
    masters { <IP_PRAB>; };
    file "/var/lib/bind/<xxxx>.com";
};
```
simpan lalu keluar, lalu restart service seperti tadi
```
service named restart
```
selanjutnya perbarui resolver di semua node non router. Jalankan perintah ini dengan file `soal_4_client.sh` di semua node selain `rootkit` (`alpha`, `beta`, `gamma`, `delta`, `epsilon`, `abbey`, `penny`, `obladi`, `desmond`, `oblada`, `molly`, serta `prab` & `tedd`)
```
cat <<EOF > /etc/resolv.conf
nameserver <IP_PRAB>
nameserver <IP_TEDD>
nameserver 192.168.122.1
EOF
```

Atau bisa juga dengan menambahkan langsung di configure network agar selalu menyala setiap node dijalankan dengan:
```
up echo "nameserver 10.71.3.2" > /etc/resolv.conf
up echo "nameserver 10.71.3.3" >> /etc/resolv.conf
up echo "nameserver 192.168.122.1" >> /etc/resolv.conf
```

uji hasilnya dengan
```
host k15.com
```
harus mengembalikan IP dari Penny
```
host prab.k15.com
host tedd.k15.com
```
Harus mengembalikan IP `prab` dan `tedd` masing-masing.

![image](assets/soal4.png)

## Soal 5
Soal kali ini terdiri dari 2 bagian utama, `Hostname System-wide`: Setiap node (misalnya `alpha`) harus punya hostname sesuai namanya di sistem operasi (`/etc/hostname` dan `/etc/hosts`) dan `Subdomain DNS di BIND9`: Di server DNS (`prab`), buatkan Record A untuk semua node agar nama seperti alpha.k15.com, beta.k15.com, dst., bisa di-ping dan di-host dari client.

Aturan Pengecualian (prab & tedd): Subdomain prab.k15.com dan tedd.k15.com tidak perlu dibuat lagi di daftar record baru ini karena sudah dibuat sebelumnya pada Soal No. 4 sebagai Name Server.

Langkah pertamanya tambahkan record semua node di `prab`, buka terminal di node `prab` untuk mengedit file zone BIND9
```
nano /etc/bind/jarkom/k15.com
```
tambahkan record A berikut pada baris paling bawah (ganti `<IP>` dengan IP masing-masing)
```
; Record A untuk Seluruh Node
rootkit IN      A       <IP_ROOTKIT>
alpha   IN      A       <IP_ALPHA>
beta    IN      A       <IP_BETA>
gamma   IN      A       <IP_GAMMA>
delta   IN      A       <IP_DELTA>
epsilon IN      A       <IP_EPSILON>
abbey   IN      A       <IP_ABBEY>
penny   IN      A       <IP_PENNY>
obladi  IN      A       <IP_OBLADI>
desmond IN      A       <IP_DESMOND>
oblada  IN      A       <IP_OBLADA>
molly   IN      A       <IP_MOLLY>
```
Di bagian atas file zone, ubah Serial dari 2026100101 menjadi 2026100105 (supaya Node tedd mau melakukan sync/transfer zone otomatis), simpan lalu keluar. Cek syntax dan restart
```
named-checkzone k15.com /etc/bind/jarkom/k15.com
service named restart
```
Langkah kedua set hostname di masing-masing node kecuali `rootkid` seperti tadi, tujuannya agar saat berada di terminal node tersebut sistemnya tau siapa dirinya sendiri. Buka terminal masing-masing node lalu jalankan (jika manual)
```
hostname alpha && echo "alpha" > /etc/hostname
hostname beta && echo "beta" > /etc/hostname
hostname gamma && echo "gamma" > /etc/hostname
hostname delta && echo "delta" > /etc/hostname
hostname epsilon && echo "epsilon" > /etc/hostname
hostname abbey && echo "abbey" > /etc/hostname
hostname penny && echo "penny" > /etc/hostname
hostname obladi && echo "obladi" > /etc/hostname
hostname desmond && echo "desmond" > /etc/hostname
hostname oblada && echo "oblada" > /etc/hostname
hostname molly && echo "molly" > /etc/hostname
hostname prab && echo "prab" > /etc/hostname
hostname tedd && echo "tedd" > /etc/hostname
```

**ATAU**, kita juga bisa menambahkan langsung di configure network agar selalu menyala setiap node. Ditambahkannya itu setelah bagian `nameserver 192.168.122.1`.

router sentral rootkit:
```
up hostname rootkit && echo "rootkit" > /etc/hostname
up echo "127.0.1.1 rootkit" >> /etc/hosts
```

alpha:
```
up hostname alpha && echo "alpha" > /etc/hostname
up echo "127.0.1.1 alpha" >> /etc/hosts
```

beta:
```
up hostname beta && echo "beta" > /etc/hostname
up echo "127.0.1.1 beta" >> /etc/hosts
```

gamma:
```
up hostname gamma && echo "gamma" > /etc/hostname
up echo "127.0.1.1 gamma" >> /etc/hosts
```

abbey:
```
up hostname abbey && echo "abbey" > /etc/hostname
up echo "127.0.1.1 abbey" >> /etc/hosts
```

penny:
```
up hostname penny && echo "penny" > /etc/hostname
up echo "127.0.1.1 penny" >> /etc/hosts
```

delta:
```
up hostname delta && echo "delta" > /etc/hostname
up echo "127.0.1.1 delta" >> /etc/hosts
```

epsilon:
```
up hostname epsilon && echo "epsilon" > /etc/hostname
up echo "127.0.1.1 epsilon" >> /etc/hosts
```

prab:
```
up hostname prab && echo "prab" > /etc/hostname
up echo "127.0.1.1 prab" >> /etc/hosts
```

tedd:
```
up hostname tedd && echo "tedd" > /etc/hostname
up echo "127.0.1.1 tedd" >> /etc/hosts
```

obladi:
```
up hostname obladi && echo "obladi" > /etc/hostname
up echo "127.0.1.1 obladi" >> /etc/hosts
```

desmond:
```
up hostname desmond && echo "desmond" > /etc/hostname
up echo "127.0.1.1 desmond" >> /etc/hosts
```

oblada:
```
up hostname oblada && echo "oblada" > /etc/hostname
up echo "127.0.1.1 oblada" >> /etc/hosts
```

molly:
```
up hostname molly && echo "molly" > /etc/hostname
up echo "127.0.1.1 molly" >> /etc/hosts
```

Kemudian, execute script `soal_5.sh` untuk memperbarui jika mengikuti langkah yang "up hostname..."

setelah itu ketik `hostname` di terminal node manapun dia bakal menjawab dirinya sendiri.

![image](assets/soal5.png)

![image](assets/soal5.2.png)

Uji subdomain node (misal dari alpha) dengan:
```
ping -c 2 beta.k15.com
host molly.k15.com
host penny.k15.com
```

## Soal 6
Soal kali ini verifikasi sinkronisasi otomatis antara DNS Master `prab` dan DNS Slave `tedd`.

Ketika memperbarui data DNS atau menaikkan angka Serial di `prab`, `prab` akan mengirimkan sinyal (NOTIFY) ke `tedd`. Kemudian `tedd` akan meminta salinan data zone terbaru melalui proses yang disebut Zone Transfer (AXFR/IXFR).

Zone Transfer Berjalan: Pastikan tedd berhasil menarik file zone dari prab tanpa ada permission error atau refused connection.

Serial SOA Identik: Angka Serial pada Record SOA di node tedd harus sama persis dengan angka Serial di prab (contoh: 2026100105).

Langkah pertama cek angka serial SOA di master `prab`, jalankan di terminal `prab`
```
dig @10.71.3.2 k15.com SOA +short
```
output yang keluar
```
prab.k15.com. root.k15.com. 2026100105 604800 86400 2419200 604800
```

![image](assets/soal6.png)

selanjutnya cek angka serial SOA di slave `tedd`, jalankan di terminal `tedd`
```
dig @10.71.3.3 k15.com SOA +short
```
output yang keluar
```
prab.k15.com. root.k15.com. 2026100105 604800 86400 2419200 604800
```

![image](assets/soal6.2.png)

Langkah ketiga memastikan file salinan zona benar-benar diterima dari prab, jalankan perintah berikut di terminal `tedd`
```
ls -l /var/lib/bind/k15.com
```
jika file belum dibentuk di direktori maka harus membuat dulu
```
mkdir -p /var/lib/bind
chown -R bind:bind /var/lib/bind
chmod 755 /var/lib/bind
```
lalu pastikan konfigurasi slave di /etc/bind/named.conf.local sudah benar menunjuk ke master `prab` (10.71.3.2)
```
cat <<EOF > /etc/bind/named.conf.local
zone "k15.com" {
    type slave;
    masters { 10.71.3.2; };
    file "/var/lib/bind/k15.com";
};
EOF
```
restart BIND9 di `prab` dan `tedd`
```
service named restart
```
verifikasi kembali
```
ls -l /var/lib/bind/k15.com
```
![image](assets/soal6.3.png)

langkah terakhir verifikasi serial SOA jika kedua perintah tersebut memunculkan nomor serial yang sama persis (misalnya 2026100105), maka poin konfigurasi DNS Master-Slave ini sudah selesai.

`prab`
```
dig @10.71.3.2 k15.com SOA +short
```

`tedd`
```
dig @10.71.3.3 k15.com SOA +short
```

![image](assets/soal6.4.png)

![image](assets/soal6.5.png)

Alternatifnya, bisa tinggal mengeksekusi skrip `soal_6_prab.sh` dan `soal_6_tedd.sh`.

## Soal 7
Pada soal ini kita diminta untuk menambahkan  pada zona `k15.com` A record untuk `vault.k15.com` (IP obladi & desmond), dan `core.k15.com` (IP oblada & molly). Kita juga tetapkan CNAME:  
- `www.k15.com` → `penny.k15.com`
- `static.k15.com` → `abbey.k15.com`

Lalu kita akan verifikasi dari dua klien berbeda bahwa seluruh hostname tersebut ter-resolve ke tujuan yang benar dan konsisten.

Pada node `prab`, buka file database zona yang terletak di `/etc/bind/jarkom/k15.com`:
```
nano /etc/bind/jarkom/k15.com
```

WAJIB lakukan penambahan angka serial pada baris SOA:
```
(misal dari `2026100105` menjadi `2026100107`).
```
![image](/assets/soal7.png)
Hal ini wajib dilakukan agar BIND9 mengenali adanya pembaruan data dan mengirim sinyal NOTIFY ke server slave (`tedd`). Tambahkan juga Record A dan CNAME dengan tambahan baris berikut di bagian bawah file:
```
; Soal 7: A Record vault (obladi & desmond) - DNS Round Robin
vault   IN      A       10.71.3.4
vault   IN      A       10.71.3.5

; Soal 7: A Record core (oblada & molly) - DNS Round Robin
core    IN      A       10.71.3.6
core    IN      A       10.71.3.7

; Soal 7: CNAME Records
www     IN      CNAME   penny.k15.com.
static  IN      CNAME   abbey.k15.com.
```
![image](/assets/soal7.1.png)
Simpan file dengan menekan `Ctrl + O` lalu tekan `Enter`, kemudian keluar menggunakan `Ctrl + X`.

Kemudian kita restart layanan di `prab`. Sebelum merestart layanan, periksa apakah ada kesalahan sintaks atau format penulisan:
```
named-checkzone k15.com /etc/bind/jarkom/k15.com
```

Jika sudah valid (OK), jalankan:
```
service named restart
```

Setelah itu, sinkronisasi di terminal node `tedd` (Slave DNS).
```
service named restart
sleep 2
dig @10.71.3.3 k15.com SOA +short
```
![image](/assets/soal7.2.png)  
Pastikan nomor serial yang keluar sudah sama (`2026100107`).

Verifikasi dari Klien 1 (`alpha`):
```
# 1. Tes vault.k15.com (harus merespons IP obladi & desmond)
host vault.k15.com

# 2. Tes core.k15.com (harus merespons IP oblada & molly)
host core.k15.com

# 3. Tes CNAME www.k15.com (alias ke penny.k15.com -> 10.71.4.2)
host www.k15.com

# 4. Tes CNAME static.k15.com (alias ke abbey.k15.com -> 10.71.2.2)
host static.k15.com
```
![image](/assets/soal7.3.png)

Verifikasi dari Klien 2 (`delta`)
```
host vault.k15.com
host core.k15.com
host www.k15.com
host static.k15.com
```
![image](/assets/soal7.4.png)

Hasilnya, node `delta` memberikan jawaban yang konsisten dan mengembalikan pasangan IP serta alias yang sama seperti pada node `alpha`.