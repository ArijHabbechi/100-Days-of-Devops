
### Task Details  
> **xFusionCorp Industries** is planning to host a **WordPress website** on their infra in **Stratos Datacenter**.  
Infrastructure setup is already done — for example, on the storage server a shared directory `/vaw/www/html` is mounted on each app host under `/var/www/html`.  

Perform the following:  

a. Install **httpd, PHP and dependencies** on all app hosts.  
b. Configure Apache to serve on **port 3004** within the app servers.  
c. Install and configure **MariaDB server** on the DB server.  
d. Create a database named **kodekloud_db2** and a user **kodekloud_aim** with password `YchZHRcLkL`. This user must be able to perform **all operations** on that database.  
e. Finally, confirm the application is accessible through the LBR link, showing the message:  
`App is able to connect to the database using user kodekloud_aim`.  

---

### Solution  

#### On each App Server  

Install PHP repo, enable latest PHP module, and install Apache + PHP with dependencies:  
```bash
sudo dnf install epel-release -y
sudo dnf install https://rpms.remirepo.net/enterprise/remi-release-$(rpm -E %rhel).rpm -y
sudo dnf module enable php:remi-8.3 -y
sudo dnf install php php-cli php-common php-curl php-mbstring php-mysqlnd php-xml -y
yum install httpd -y
```
Configure Apache to listen on port 3004:

```bash

sudo sed -i 's/^Listen 80$/Listen 3004/' /etc/httpd/conf/httpd.conf
```
Enable and start Apache:

```bash
systemctl enable httpd
systemctl start httpd
```
### On the DB Server
Install and start MariaDB server:

```bash
yum install mariadb-server -y
systemctl enable mariadb
systemctl start mariadb
```
Log into MySQL and configure database + user: 
In the CLI : ```mysql ```
```sql
CREATE DATABASE kodekloud_db2;

CREATE USER 'kodekloud_aim'@'%' IDENTIFIED BY 'YchZHRcLkL';

GRANT ALL PRIVILEGES ON kodekloud_db2.* TO 'kodekloud_aim'@'%';

FLUSH PRIVILEGES;
```

### 🧠 BONUS : Quick Commands Recap
| Component    | Command Example                                              |
|--------------|--------------------------------------------------------------|
| Apache Port  | sed -i 's/^Listen 80$/Listen 3004/' /etc/httpd/conf/httpd.conf |
| Start Apache | systemctl start httpd && systemctl enable httpd              |
| PHP Install  | dnf module enable php:remi-8.3 && dnf install php php-mysqlnd |
| DB Install   | yum install mariadb-server -y && systemctl start mariadb     |
| DB Setup     | CREATE DATABASE kodekloud_db2;                               |
| User Setup   | CREATE USER 'kodekloud_aim'@'%' IDENTIFIED BY 'YchZHRcLkL';  |
| Privileges   | GRANT ALL PRIVILEGES ON kodekloud_db2.* TO 'kodekloud_aim'@'%'; |
### 🔐 Notes: 
-   The `%` in the user host allows connections from any host, so app servers can connect.
- **For production, restrict DB user host (%) to only the app servers’ IPs.**

