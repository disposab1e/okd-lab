# GitLab SSH Keys and Access Token

< [Install OKD4](03_install_okd.md)

* * *

Point your Firefox to [https://gitlab.okd.example.com](https://gitlab.okd.example.com) and login via `LDAP` as user `lab` with password `lab`.

![Login](images/gitlab/01.png)

## Edit profile 

![Edit profile](images/gitlab/02.png)

### Add SSH key 

Add user `lab` SSH public key from `~/.ssh/id_rsa.pub`

![Add SSH key](images/gitlab/03.png)

![Add SSH key](images/gitlab/04.png)

### Create Access Token

Create a new personal access token and save it for further usage.

![Access Token](images/gitlab/05.png)

![Access Token](images/gitlab/06.png)

### Save Access Token

![Save Access Token](images/gitlab/07.png)
