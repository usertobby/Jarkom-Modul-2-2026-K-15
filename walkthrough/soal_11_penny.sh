cat << 'EOF' > /etc/apache2/sites-available/vault-proxy.conf
<VirtualHost *:80>
    ServerName vault.k15.com

    ProxyPreserveHost On
    ProxyPass / balancer://vaultcluster/
    ProxyPassReverse / balancer://vaultcluster/

    <Proxy balancer://vaultcluster>
        BalancerMember http://10.71.x.x route=obladi
        BalancerMember http://10.71.x.x route=desmond
        ProxySet lbmethod=byrequests
    </Proxy>
</VirtualHost>
EOF

a2ensite vault-proxy.conf
a2dissite 000-default.conf
service apache2 restart