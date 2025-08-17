
### Task Details  
The production support team of **xFusionCorp Industries** has deployed monitoring tools to check services and applications running on the systems.  
One of the monitoring systems reported **Apache service unavailability** on one of the app servers in **Stratos Datacenter**.  

**Your tasks:**  
1. Identify the faulty app host.  
2. Fix the issue and ensure **Apache is up and running on all app hosts**.  
3. Apache must be configured to run on port **8088** on all app servers.  
4. No need to worry about hosted code — just ensure the service itself is running.  

---

### Solution  
To identify the faulty app host, from the jump host : 
```bash 
curl hostname:<port>
```
Then logged into the faulty app host and verified Apache status:  
```bash
systemctl status httpd
```
Checked whether Apache was listening on port 8088:

```bash
sudo netstat -tulnp | grep :8088
```
On the faulty host, validated Apache configuration:

```bash
httpd -t
```
Edited Apache configuration file:

```bash
vi /etc/httpd/conf/httpd.conf
```
Made sure the following lines were present and active (uncommented):

```bash
Listen 8088
ServerName <server-ip>:8088
```
Restarted Apache service:

```bash
systemctl restart httpd
systemctl status httpd
```

If another process was blocking the port, identified and killed it:

```bash
sudo netstat -tulnp | grep :8088
kill -9 <pid>
systemctl restart httpd
```
Finally confirmed Apache was active and bound to port 8088:

```bash
sudo netstat -tulnp | grep :8088
```
### Explanation
* Apache by default listens on port 80. Here it needed to be configured on 8088.
* In /etc/httpd/conf/httpd.conf, the line #ServerName was uncommented and set to the server’s IP with port 8088.
* After fixing configuration, httpd -t was used to validate the syntax.
* Restarted Apache to apply changes.
* If another service was occupying 8088, the PID was terminated before restarting Apache.

**Finally, systemctl status httpd and netstat confirmed the service was up and running.**

### 🧠 BONUS : Useful Apache & Network Commands

| Command                          | Purpose                                      |
|----------------------------------|----------------------------------------------|
| systemctl status httpd           | Check Apache service status                  |
| systemctl start httpd            | Start Apache service                         |
| systemctl restart httpd          | Restart Apache service                       |
| httpd -t                         | Validate Apache configuration syntax         |
| netstat -tulnp | grep :8088       | Check if Apache is listening on port 8088    |
| kill -9 <pid>                    | Kill a process occupying a required port     |
| journalctl -xe -u httpd          | View Apache error logs                       |
### 🔐 Tips
*  Always run httpd -t before restarting Apache to avoid crashes from bad configs.
* When using non-default ports (like 8088), ensure firewall and SELinux are not blocking.
* Use journalctl -xe -u httpd to debug service startup issues.
* Double-check for conflicting processes on the target port with netstat/ss.
