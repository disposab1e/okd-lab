# Appendix

## Unix Users

| Username  	| Password  	| Host  	|
|---	|---	|---	|
| lab  	| lab*  	| lab.okd.example.com  	|
| root  	| root*  	| lab.okd.example.com  	|
| root  	| root  	| bastion.okd.example.com  	|
| root  	| root  	| lb.okd.example.com  	|

*If you have followed the installation documentation.


## URL's and superuser logins

| Service  	| URL  	| Admin  	| Password  	|
|---	|---	|---	|---	|
| Cockpit* (lab)  	| http://localhost:9090  	| root  	| root  	|
| Cockpit* (bastion)  	| https://bastion.okd.example.com:9090  	| root  	| root  	|
| Mirrors  	| http://mirror.okd.example.com  	|   	|   	|
| Load Balancer statistics  	| https://lb.okd.example.com:9000  	|   	|   	|
| GitLab* 	| https://gitlab.okd.example.com  	| root  	| rootroot  	|
| Quay  	| https://quay.okd.example.com  	| admin  	| admin  	|
| Artifactory  	| https://artifactory.okd.example.com  	| admin  	| admin  	|

*Please Note: Admin/Root Accounts of these services are mostly not maintained with LDAP.

## 389-Directory 

### admin

| cn  	| Password  	|
|---	|---	|
| cn=Directory Manager  	| directory  	|

### groups

| dn  	|
|---	|
| ou=Groups,dc=example,dc=com  	|

### users

| dn  	|
|---	|
| ou=People,dc=example,dc=com  	|

| Username  	| Password  	| Email  	| dn    |
|---	|---	|---	|---	|
| admin  	| admin  	| admin@example.com  	| uid=admin,ou=People,dc=example,dc=com |
| lab  	| lab  	| lab@example.com  	| uid=lab,ou=People,dc=example,dc=com |
| awesome-admin  	| admin  	| awesome-admin@example.com  	| uid=awesome-admin,ou=People,dc=example,dc=com |
| awesome-developer  	| developer  	| awesome-developer@example.com  	| uid=awesome-developer,ou=People,dc=example,dc=com |

## Software Versions

| Software  	| Version  	|
|---	|---	|
| CentOS  	| 8.3.2011  	|
| Terraform  	| 0.13.6  	|
| Terraform KVM Plugin  	| v0.6.3  	|
| Packer  	| 1.7.0  	|
| Ansible  	| 2.9.18  	|
| Project Quay / Clair 	| qui-gon (newer versions with ldap problems!) 	|
| 389-Directory Server  	| 1.4.3.17  	|
| Artifactory  	| 7.16.3  	|
| GitLab  	| 13.9.3-ce.0   	|
| Rook  	| 1.5.9 	|

## Network

Inspect the DNS [example.com zone file](https://github.com/disposab1e/okd-lab/blob/master/ansible/bastion/roles/bind/files/db.example.com) to get an overview.
