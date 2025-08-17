
### Task Details  
>The system admins team of **xFusionCorp Industries** needs to deploy a new application on **App Server 2** in **Stratos Datacenter**.  

They have some prerequisites to prepare the server for application deployment:  

1. Install and configure **nginx** on App Server 2.  
2. On App Server 2 there is a self-signed SSL certificate and key present at `/tmp/nautilus.crt` and `/tmp/nautilus.key`. Move them to the appropriate location and configure Nginx to use them.  
3. Create an `index.html` file with content `Welcome!` under the Nginx document root.  
4. For final testing, access App Server 2 from the jump host using curl:  
   ```bash
   curl -Ik https://<app-server-ip>/ 
   ```

### Solution
Logged into App Server 2:

```bash
ssh steve@stapp02
sudo -i
```
Installed nginx:

```bash
yum install -y nginx
```
Created directory for SSL private key:

```bash
mkdir -p /etc/pki/nginx/private
```
Moved SSL certificate and key to appropriate locations:

```bash
mv /tmp/nautilus.crt /etc/pki/nginx/server.crt
mv /tmp/nautilus.key /etc/pki/nginx/private/server.key
```
Edited Nginx configuration to enable SSL:

```bash
vi /etc/nginx/nginx.conf
```
Uncommented  the TLS server block:

```nginx
server {
    listen       443 ssl http2;
    listen       [::]:443 ssl http2;
    server_name  _;  
    root         /usr/share/nginx/html;

    ssl_certificate "/etc/pki/nginx/server.crt";
    ssl_certificate_key "/etc/pki/nginx/private/server.key";
    ssl_session_cache shared:SSL:1m;
    ssl_session_timeout 10m;
    ssl_ciphers PROFILE=SYSTEM;
    ssl_prefer_server_ciphers on;

    include /etc/nginx/default.d/*.conf;

    error_page 404 /404.html;
    location = /40x.html {}

    error_page 500 502 503 504 /50x.html;
    location = /50x.html {}
}
```
Validated configuration:
```bash
nginx -t
```
Enabled and started Nginx service:

```bash
systemctl enable nginx
systemctl start nginx
```
Created a test page:
```bash
echo "Welcome!" > /usr/share/nginx/html/index.html
```
Restarted Nginx:
```bash
systemctl restart nginx
```
Test access from App Server 2 locally or from the jump host :
```bash
curl -k https://localhost/
```
Expected output:
**Welcome!**



### 🧠 BONUS : Useful Nginx Commands Recap

| Command                  | Purpose                                |
|--------------------------|----------------------------------------|
| nginx -t                 | Test nginx configuration for errors    |
| systemctl start nginx    | Start nginx service                    |
| systemctl restart nginx  | Restart nginx service                  |
| systemctl enable nginx   | Enable nginx at boot                   |
| tail -f /var/log/nginx/* | Check Nginx access/error logs          |

### 🔐 Tips & SSL Notes
* Always test (nginx -t) before restarting Nginx.
* Use -k with curl to skip SSL verification when testing self-signed certs.
* Store certificates and keys under /etc/pki/nginx/ for consistency.
* Keep a backup of the original nginx.conf before making changes.
---
---
###  SSL / TLS & Self-Signed Certificates Notes

SSL/TLS basics: SSL (Secure Sockets Layer) and its successor TLS provide encryption, integrity, and authentication for communication between client (like  browsers) and server(like Nginx).
*-   Without SSL, data (like passwords, tokens, etc.) is sent in plain text. With SSL, it’s encrypted.*
*-   Certificates also help browsers verify that they’re really talking to the server they expect.*

**Encryption**: Data exchanged (like passwords, cookies, API calls) is unreadable to anyone intercepting traffic.

**Integrity**: Ensures the data is not modified in transit (protects against MITM tampering).

**Authentication**: Certificates prove the server’s identity to the client.

### ***Self-signed certificates:***

Normally, certificates are issued by Certificate Authorities (CAs) trusted by browsers and operating systems.

A self-signed cert skips the CA and is generated locally (like the nautilus.crt we used).

They provide encryption and integrity, but not trusted authentication , that’s why tools like curl or browsers will warn: “certificate not trusted”.

For internal apps, testing, or lab environments, self-signed certs are fine.

For production and public access, you should use a trusted CA (e.g., Let’s Encrypt, DigiCert).


