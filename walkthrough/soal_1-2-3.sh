# ==== rootkit (gateway) ====
cat <<EOF > /etc/network/interfaces
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet dhcp
up sysctl -w net.ipv4.ip_forward=1
up iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE

auto eth1
iface eth1 inet static
    address 10.71.1.1
    netmask 255.255.255.0

auto eth2
iface eth2 inet static
    address 10.71.2.1
    netmask 255.255.255.0

auto eth3
iface eth3 inet static
    address 10.71.3.1
    netmask 255.255.255.0

auto eth4
iface eth4 inet static
    address 10.71.4.1
    netmask 255.255.255.0

auto eth5
iface eth5 inet static
    address 10.71.5.1
    netmask 255.255.255.0
EOF

# ======= switch 6 (pengamat) =======
# ==== alpha ====
cat <<EOF > /etc/network/interfaces
auto eth0
iface eth0 inet static
	address 10.71.1.2
	netmask 255.255.255.0
	gateway 10.71.1.1
	up echo "nameserver 192.168.122.1" > /etc/resolv.conf
EOF

# ==== beta ====
cat <<EOF > /etc/network/interfaces
auto eth0
iface eth0 inet static
	address 10.71.1.3
	netmask 255.255.255.0
	gateway 10.71.1.1
	up echo "nameserver 192.168.122.1" > /etc/resolv.conf
EOF

# ==== gamma ====
cat <<EOF > /etc/network/interfaces
auto eth0
iface eth0 inet static
	address 10.71.1.4
	netmask 255.255.255.0
	gateway 10.71.1.1
	up echo "nameserver 192.168.122.1" > /etc/resolv.conf
EOF

# ======= switch 4 =======
# ==== abbey (reverse proxy) ====
cat <<EOF > /etc/network/interfaces
auto eth0
iface eth0 inet static
    address 10.71.2.2
    netmask 255.255.255.0
    gateway 10.71.2.1
    up echo "nameserver 192.168.122.1" > /etc/resolv.conf
EOF

# ======= switch 5 =======
# ==== penny (reverse proxy) ====
cat <<EOF > /etc/network/interfaces
auto eth0
iface eth0 inet static
    address 10.71.4.2
    netmask 255.255.255.0
    gateway 10.71.4.1
    up echo "nameserver 192.168.122.1" > /etc/resolv.conf
EOF

# ======= switch 7 (eksekutor) =======
# ==== delta ====
cat <<EOF > /etc/network/interfaces
auto eth0
iface eth0 inet static
    address 10.71.5.2
    netmask 255.255.255.0
    gateway 10.71.5.1
    up echo "nameserver 192.168.122.1" > /etc/resolv.conf
EOF

# ==== epsilon ====
cat <<EOF > /etc/network/interfaces
auto eth0
iface eth0 inet static
    address 10.71.5.3
    netmask 255.255.255.0
    gateway 10.71.5.1
    up echo "nameserver 192.168.122.1" > /etc/resolv.conf
EOF


# INI BELUM DI BAWAH INI
# ======= klaster layanan switch 1 =======

# ======= switch 2 =======
# ==== prab (ns1) ====
cat <<EOF > /etc/network/interfaces
auto eth0
iface eth0 inet static
    address 10.71.3.2
    netmask 255.255.255.0
    gateway 10.71.3.1
    up echo "nameserver 192.168.122.1" > /etc/resolv.conf
EOF

# ==== tedd (ns2) ====
cat <<EOF > /etc/network/interfaces
auto eth0
iface eth0 inet static
    address 10.71.3.3
    netmask 255.255.255.0
    gateway 10.71.3.1
    up echo "nameserver 192.168.122.1" > /etc/resolv.conf
EOF

# ======= switch 3 =======
# ==== obladi (web statis) ====
cat <<EOF > /etc/network/interfaces
auto eth0
iface eth0 inet static
    address 10.71.3.4
    netmask 255.255.255.0
    gateway 10.71.3.1
    up echo "nameserver 192.168.122.1" > /etc/resolv.conf
EOF

# ==== desmond (web statis) ====
cat <<EOF > /etc/network/interfaces
auto eth0
iface eth0 inet static
    address 10.71.3.5
    netmask 255.255.255.0
    gateway 10.71.3.1
    up echo "nameserver 192.168.122.1" > /etc/resolv.conf
EOF

# ==== oblada (web dinamis) ====
cat <<EOF > /etc/network/interfaces
auto eth0
iface eth0 inet static
    address 10.71.3.6
    netmask 255.255.255.0
    gateway 10.71.3.1
    up echo "nameserver 192.168.122.1" > /etc/resolv.conf
EOF

# ==== molly (web dinamis) ====
cat <<EOF > /etc/network/interfaces
auto eth0
iface eth0 inet static
    address 10.71.3.7
    netmask 255.255.255.0
    gateway 10.71.3.1
    up echo "nameserver 192.168.122.1" > /etc/resolv.conf
EOF