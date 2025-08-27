
### Task Details
> The Nautilus application development team is launching a new **PHP-based** application on **App Server 2 (stapp02)** in **Stratos DC**.

**Requirements**
- Install **nginx** on app server 2, listen on **port 8092**, **document root** `/var/www/html`.
- Install **php-fpm 8.3** and make it listen on the **Unix socket** `/var/run/php-fpm/default.sock` (create parent dirs if needed).
- Wire **nginx ↔ php-fpm** together.
- Verify from the jump host:
  ```bash
  curl http://stapp02:8092/index.php
### Solution 
Log in to stapp02 and become root : 

**1) Install & enable Nginx (port 8092, docroot /var/www/html)**
```bash
yum install -y nginx
```
*Installs the reverse proxy / web server that will front the PHP app.*

Edit /etc/nginx/nginx.conf → under the http { ... } block, ensure a server like:

```nginx
server {
    listen 8092;
    server_name _;
    root /var/www/html;           # document root
    index index.php index.html;

    location / {
        try_files $uri $uri/ =404;  # serve files or 404
    }

    # PHP handling (fastcgi to php-fpm socket)
    location ~ \.php$ {
        include fastcgi_params;
        fastcgi_pass unix:/var/run/php-fpm/default.sock;
        fastcgi_index index.php;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
    }
}
```
Start and enable Nginx:

```bash
systemctl enable nginx
systemctl start nginx
```
*Nginx must be active and persistent across reboots.*

**2) Install PHP-FPM 8.3 and configure its Unix socket
Enable Remi repo & PHP 8.3 module; install php-fpm:**

```bash
dnf install -y https://rpms.remirepo.net/enterprise/remi-release-9.rpm
dnf module reset -y php
dnf module enable -y php:remi-8.3
dnf install -y php-fpm
```
*Base repos often don’t ship 8.3; Remi provides maintained PHP streams.*

Edit the default pool config /etc/php-fpm.d/www.conf:

```ini
user = nginx
group = nginx

; required socket path for this task
listen = /var/run/php-fpm/default.sock

; make the socket owned by nginx so nginx can connect
listen.owner = nginx
listen.group = nginx
```
Create the socket directory and set permissions:

```bash
mkdir -p /var/run/php-fpm
chown -R nginx:nginx /var/run/php-fpm
```
Enable and start php-fpm:

```bash
systemctl enable --now php-fpm
systemctl restart php-fpm
```

*Unix socket vs TCP: Faster on a single host (no IP stack), and file permissions control access.*


**3) Validate configs and create a test page**
Test Nginx syntax and reload if needed:

```bash
nginx -t
systemctl restart nginx
```

##### Verification
From jump host:
```bash
curl http://stapp02:8092/index.php
```
Expected:
#### Welcome to xFusionCorp  App! 

### Tips for Troubleshooting 
*  **404 Not Found**: file path wrong; ensure /var/www/html/index.php exists and root points to /var/www/html.

* **502 Bad Gateway**: Nginx can’t reach the socket. Check:

	* fastcgi_pass path == listen path in www.conf (/var/run/php-fpm/default.sock)

	* Socket exists: ls -l /var/run/php-fpm/default.sock

	* Ownership/permissions: owned by nginx:nginx

	* Services: systemctl status php-fpm nginx

* Wrong PHP version: php-fpm -v should report PHP 8.3.x (fpm-fcgi). If not, re-check Remi module enablement.
