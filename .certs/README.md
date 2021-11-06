# Create CA and certs

## Create Ca

mkdir ~/github/okd-lab/.ca/
ln -s /usr/share/easy-rsa/3/* ~/github/okd-lab/.ca/

cd ~/github/okd-lab/.ca
./easyrsa init-pki
./easyrsa build-ca nopass

## Create csr's

cd ~/github/okd-lab/.certs

### Bastion
openssl genrsa -out bastion-server.key
openssl req -new -days 3650 -key bastion-server.key -out bastion-server.req -config bastion-server.cnf

### LDAP
openssl genrsa -out ldap-server.key
openssl req -new -days 3650 -key ldap-server.key -out ldap-server.req -config ldap-server.cnf

### Loadbalancer
openssl genrsa -out lb-server.key
openssl req -new -days 3650 -key lb-server.key -out lb-server.req -config lb-server.cnf

### Rook Admission Controller
openssl genrsa -out rook.key 2048
openssl req -new -key rook.key -subj "/CN=rook-ceph-admission-controller.rook-ceph.svc" -out rook.csr -config rook.cnf

### OKD Apps
openssl genrsa -out okd-apps.key
openssl req -new -days 3650 -key okd-apps.key -out okd-apps.req -config okd-apps.cnf

### OKD API
openssl genrsa -out okd-api.key
openssl req -new -days 3650 -key okd-api.key -out okd-api.req -config okd-api.cnf


## Sign csr's

cd ~/github/okd-lab/.ca

# Bastion
./easyrsa import-req ~/github/okd-lab/.certs/bastion-server.req bastion-server
./easyrsa sign-req server bastion-server

# LDAP
./easyrsa import-req ~/github/okd-lab/.certs/ldap-server.req ldap-server
./easyrsa sign-req server ldap-server

# Loadbalancer
./easyrsa import-req ~/github/okd-lab/.certs/lb-server.req lb-server
./easyrsa sign-req server lb-server

# Rook Admission Controller
./easyrsa import-req ~/github/okd-lab/.certs/rook.csr rook
./easyrsa sign-req server rook

### OKD Apps
./easyrsa import-req ~/github/okd-lab/.certs/okd-apps.req okd-apps
./easyrsa sign-req server okd-apps

### OKD API
./easyrsa import-req ~/github/okd-lab/.certs/okd-api.req okd-api
./easyrsa sign-req server okd-api


## Get CA and certs
cp ~/github/okd-lab/.ca/pki/issued/* ~/github/okd-lab/.certs
cp ~/github/okd-lab/.ca/pki/ca.crt ~/github/okd-lab/.certs


## Publish key and certs

cp ~/github/okd-lab/.ca/pki/ca.crt ~/github/okd-lab/ansible/bastion/roles/ca/files

cp ~/github/okd-lab/.certs/bastion-server.key  ~/github/okd-lab/ansible/bastion/roles/nginx/files
cp ~/github/okd-lab/.certs/bastion-server.crt  ~/github/okd-lab/ansible/bastion/roles/nginx/files

cp ~/github/okd-lab/.certs/ldap-server.key  ~/github/okd-lab/ansible/bastion/roles/389-directory/files
cp ~/github/okd-lab/.certs/ldap-server.crt  ~/github/okd-lab/ansible/bastion/roles/389-directory/files

cp ~/github/okd-lab/.certs/lb-server.key  ~/github/okd-lab/ansible/lb/roles/haproxy/files
cp ~/github/okd-lab/.certs/lb-server.crt  ~/github/okd-lab/ansible/lb/roles/haproxy/files

Add ~/github/okd-lab/.ca/pki/ca.crt to:
~/github/okd-lab/ansible/okd/roles/env/templates/install-config.yaml.j2

Add ~/github/okd-lab/.ca/pki/ca.crt two times to:
~/github/okd-lab/ansible/okd/roles/okd-config/files/example-com-ca.yaml

Add ~/github/okd-lab/.ca/pki/ca.crt to:
~/github/okd-lab/gitops/cluster/runtime/base/argocd/kustomization.yaml