# Appendix

## Linux Users

| Username  	| Password  	| Host  	|
|---	|---	|---	|
| lab  	| lab*  	| lab.okd.example.com  	|
| root  	| root*  	| lab.okd.example.com  	|
| root  	| root  	| bastion.okd.example.com  	|
| root  	| root  	| lb.okd.example.com  	|

*If you have followed the documented installation process.

## URL's and logins

### Cockpit, Mirror, GitLab, Artifactory, Project Quay,Loadbalancer

| Service  	| URL  	| Admin  	| Password  	|
|---	|---	|---	|---	|
| Cockpit* (lab)  	| http://localhost:9090  	| root  	| root  	|
| Cockpit* (bastion)  	| https://bastion.okd.example.com:9090  	| root  	| root  	|
| Mirrors  	| http://mirror.okd.example.com  	|   	|   	|
| Load Balancer statistics  	| https://lb.okd.example.com:9000  	|   	|   	|
| GitLab* 	| https://gitlab.okd.example.com  	| admin (LDAP)  	| admin  	|
|   	|     | lab (LDAP)  	| lab  	|
|   	|     | root (local)  	| rootroot |   
| Artifactory  	| https://artifactory.okd.example.com  	| admin (LDAP)  	| admin  	|
|   	|     | lab (LDAP)  	| lab  	|
| Project Quay  	| https://quay.okd.example.com  	| admin (LDAP)  	| admin  	|
|   	|     | lab (LDAP)  	| lab  	|
| Project Quay API (Swagger) 	| http://10.0.2:8222  	|   	|   	|

*Please Note: Admin/Root Accounts of these services are not maintained with LDAP.

### OKD

| Service  	| URL  	| Admin  	| Password  	|
|---	|---	|---	|---	|
| OKD4  	| https://console-openshift-console.apps.okd.example.com    | admin (LDAP)  	| admin	|
|   	|     | lab (LDAP)  	| lab  	|
|   	|     | awesome-admin (LDAP)  	| awesome-admin  	|
|   	|     | awesome-developer (LDAP)  	| awesome-developer  	|
|   	|     | kubeadmin (local)  	| ssh lab@bastion "cat ~/installer/auth/kubeadmin-password" > ~/github/okd-lab/.secrets/kubeadmin  	|
| ArgoCD  	| https://argocd.apps.okd.example.com    | admin (LDAP)  	| admin	|
|   	|     | lab (LDAP)  	| lab  	|
|   	|     | awesome-admin (LDAP)  	| awesome-admin  	|
|   	|     | awesome-developer (LDAP)  	| awesome-developer  	|
|   	|     | admin (local)  	|   oc get secret argocd-initial-admin-secret -n argocd -o jsonpath="{['data']['password']}" | base64 --decode && echo	|
| Argo Workflows  	| https://argo.apps.okd.example.com    | admin (LDAP)  	| admin	|
|   	|     | lab (LDAP)  	| lab  	|
|   	|     | awesome-admin (LDAP)  	| awesome-admin  	|
|   	|     | awesome-developer (LDAP)  	| awesome-developer  	|
| Kyverno Policy Reporter  	| https://kyverno.apps.okd.example.com    |   	| 	|
| Tekton Dashboard  	| https://tekton.apps.okd.example.com    |   	| 	|
| Rook Dashboard  	| https://rook.apps.okd.example.com    |  admin 	| oc get secret rook-ceph-dashboard-password  -n rook-ceph -o jsonpath="{['data']['password']}" | base64 --decode && echo	|
| Grafana  	| https://grafana-route-grafana.apps.okd.example.com    | admin (LDAP)  	| admin	|
|   	|     | lab (LDAP)  	| lab  	|
|   	|     | admin (local)  	|   oc get secret grafana-admin-credentials  -n grafana -o jsonpath="{['data']['GF_SECURITY_ADMIN_PASSWORD']}" | base64 --decode && echo 




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

## OpenShift 

| Username  	| Password  	| Group  	| Role    |
|---	|---	|---	|---	|
| admin  	| admin  	| admins  	| cluster-admin |
| lab  	| lab  	| admins  	| cluster-admin |
| awesome-admin  	| admin  	| awesome-admins  	|  |
| awesome-developer  	| developer  	| awesome-developers  	|  |


## Software Versions

| Software  	| Version  	|
|---	|---	|
| CentOS  	| 8.4.2105  	|
| Terraform  	| 1.0.10  	|
| Terraform KVM Plugin  	| v0.6.10  	|
| Packer  	| 1.7.7  	|
| Ansible  	| 2.9.25  	|
| Project Quay / Clair 	| 3.6.1	/ 4.3.0 |
| 389-Directory Server  	| 1.4.4.17  	|
| Artifactory  	| 7.27.9  	|
| GitLab  	| 14.4.1-ce.0   	|
| Rook  	| 1.7.6 	|
| ArgoCD  	| 2.1.6 	|
| Argo Workflows  	| 3.2.3 	|
| Argo Rollouts  	| 1.1.0 	|
| Argo Events  	| 1.5.0 	|
| Argo ApplicationSets  	| 0.0.2 	|
| Tekton Pipelines  	| v0.29.0 	|
| Tekton Triggers  	| v0.17.0 	|
| Tekton Dashboard  	| v0.21.0 	|
| Kyverno  	| v1.5.1 	|
| Kyverno Policy Reporter  	| 1.12.5 	|
| Shipwright  	| v0.6.0 	|
| Sealed Secrets  	| v0.16.0 	|

## Network

Inspect the DNS [example.com zone file](https://github.com/disposab1e/okd-lab/blob/master/ansible/bastion/roles/bind/files/db.example.com) to get an overview.
