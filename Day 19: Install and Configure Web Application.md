### Task Details  
**xFusionCorp Industries** is planning to host **two static websites** on their infra in **Stratos Datacenter**.  
The development of these websites is still in progress, but the servers must be prepared.  

Perform the following:  

a. Install **httpd** package and dependencies on **App Server 1**.  
b. Configure Apache to serve on **port 5002**.  
c. Two website backups are located at `/home/thor/ecommerce` and `/home/thor/apps` on the **jump host**.  
   - Setup Apache so that:  
     - `http://localhost:5002/ecommerce/` serves the ecommerce website.  
     - `http://localhost:5002/apps/` serves the apps website.  
d. Verify access with `curl http://localhost:5002/ecommerce/` and `curl http://localhost:5002/apps/` on App Server 1.  

---

### Solution  
##### Step0: Install openssh client packages on App server 1: 
```bash
yum install openssh-clients -y
systemctl restart sshd
```
##### Step 1: Copy site backups from Jump Host to App Server 1  
On Jump Host (thor):  
```bash
scp -r /home/thor/ecommerce tony@stapp01:/tmp
scp -r /home/thor/apps tony@stapp01:/tmp
```
##### Step 2: Install Apache on App Server 1
On App Server 1:

```bash
yum install httpd -y
```
Change Apache port to 5002:

```bash
sudo sed -i 's/^Listen 80$/Listen 5002/' /etc/httpd/conf/httpd.conf
```
Enable and start Apache:

```bash
systemctl enable httpd
systemctl start httpd
```
#####  Step 3: Move the websites into Apache document root
```bash
mv /tmp/apps /var/www/html/
mv /tmp/ecommerce /var/www/html/
```
Apache document root now contains:

```css
/var/www/html/ecommerce
/var/www/html/apps
```
#####  Step 4: Verification
On App Server 1:

```bash
curl http://localhost:5002/ecommerce/
```
Output:

```html
<!DOCTYPE html>
<html>
<body>
<h1>KodeKloud</h1>
<p>This is a sample page for our ecommerce website</p>
</body>
</html>
```

On Jump Host (remote access test):

```bash
curl http://stapp01:5002/apps/
```
Output confirmed same as above .

### Explanation
* Moved the static site backups (ecommerce and apps) into the Apache document root (/var/www/html).
* Apache automatically serves directories under /var/www/html as subpaths (/ecommerce and /apps).
