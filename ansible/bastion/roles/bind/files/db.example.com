@       IN      SOA     bastion.okd.example.com. admin.example.com. (
             3          ; Serial
             604800     ; Refresh
              86400     ; Retry
            2419200     ; Expire
             604800 )   ; Negative Cache TTL
;
; name servers - NS records
    IN      NS     bastion.okd.example.com.

; name servers - A records

bastion.okd.example.com.          IN      A      10.0.0.2
quay.okd.example.com.             IN      A      10.0.0.2
clair.okd.example.com.            IN      A      10.0.0.2
gitlab.okd.example.com.           IN      A      10.0.0.2
artifactory.okd.example.com.      IN      A      10.0.0.2
sso.okd.example.com.              IN      A      10.0.0.2
ldap.okd.example.com.             IN      A      10.0.0.2
mirror.okd.example.com.           IN      A      10.0.0.2
ntp.okd.example.com.              IN      A      10.0.0.2

bootstrap.okd.example.com.        IN      A      10.0.0.10

lb.okd.example.com.               IN      A      10.0.0.99
*.apps.okd.example.com.           IN      A      10.0.0.99
api.okd.example.com.              IN      A      10.0.0.99
api-int.okd.example.com.          IN      A      10.0.0.99
master-0.okd.example.com.         IN      A      10.0.0.100
master-1.okd.example.com.         IN      A      10.0.0.101
master-2.okd.example.com.         IN      A      10.0.0.102
etcd-0.okd.example.com.           IN      A      10.0.0.100
etcd-1.okd.example.com.           IN      A      10.0.0.101
etcd-2.okd.example.com.           IN      A      10.0.0.102
worker-0.okd.example.com.         IN      A      10.0.0.110
worker-1.okd.example.com.         IN      A      10.0.0.111
worker-2.okd.example.com.         IN      A      10.0.0.112

_etcd-server-ssl._tcp.okd.example.com 86400 IN SRV 0 10 2380 etcd-0.okd.example.com.
_etcd-server-ssl._tcp.okd.example.com 86400 IN SRV 0 10 2380 etcd-1.okd.example.com.
_etcd-server-ssl._tcp.okd.example.com 86400 IN SRV 0 10 2380 etcd-2.okd.example.com.
