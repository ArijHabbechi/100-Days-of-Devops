
### Task Details  
Day by day traffic is increasing on one of the websites managed by the Nautilus production support team. The team has observed a degradation in website performance. Following discussions, they decided to deploy this application on a **high availability stack** on Nautilus infra in **Stratos DC**. Migration is almost done; only the **LBR (load balancer) server** configuration is pending. Configure the LBR server as per the information given below:

a. Install **nginx** on the LBR server.  
b. Configure **HTTP load balancing** in the **main** Nginx config `/etc/nginx/nginx.conf`, using **all App Servers**.  
c. Do **not** change the Apache port that is already defined on the app servers; just ensure Apache is up and running on all app servers.  
d. Once done, you can access the website using the **StaticApp** button on the top bar.

---

### Solution

**Verified Apache on app servers (kept existing Apache port):**  
- Checked Apache was running and which port it listens on (example from one app:  `Listen 6300` in `httpd.conf`).  
- Did **not** modify Apache ports.

**On the LBR server:**
```bash
yum install nginx -y
vim /etc/nginx/nginx.conf
```
Edits in /etc/nginx/nginx.conf (inside the existing http { ... } block):

```nginx

upstream backend {
    server stapp01:6300;
    server stapp02:6300;
    server stapp03:6300;
}

server {
    listen 80;
    server_name _;

    location / {
        proxy_pass http://backend;
    }

    # kept the rest of the default server block as-is
}
```
I verified the config file syntax 
```bash
nginx -t
```

```bash
systemctl enable nginx
systemctl start nginx
```
