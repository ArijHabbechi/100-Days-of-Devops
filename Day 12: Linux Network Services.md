## Day 12: Linux Network Services

### Task Details  
>Our monitoring tool has reported an issue in **Stratos Datacenter**. One of our app servers has an issue, as its **Apache service is not reachable on port 8086** (which is the Apache port). The service itself could be down, the firewall could be at fault, or something else could be causing the issue.  

>Use tools like `telnet`, `netstat`, etc. to find and fix the issue.  
Also make sure Apache is reachable from the jump host without compromising any security settings.  

Once fixed, you can test the same using command:  
```bash
curl http://stapp01:8086
```

from the jump host.

### Solution

Logged into App Server 1:

```bash

ssh tony@stapp01
```
Switched to root user:

```bash
sudo -i
```
Checked Apache service:

```bash

systemctl status httpd
httpd -t
```

Then edited the Apache configuration file (if needed in your case ):

```bash
vi /etc/httpd/conf/httpd.conf
```
Ensured the following lines exist:
```bash
Listen 8086
ServerName 127.0.0.1:8086
```
Then restarted the service:

```bash

systemctl restart httpd
systemctl enable httpd
systemctl status httpd
```
Verified Apache is listening on port 8086:

```bash
ss -ltnp | grep 8086
```
If another service was using port 8086, stopped/killed it and restarted httpd:
```bash
kill -9 <pid>
systemctl restart httpd
```


To ensure that Apache is reachable from jump host, i configured firewall to allow 8086:
```bash

iptables -I INPUT -p tcp --dport 8086 -j ACCEPT
iptables-save > /etc/sysconfig/iptables
```
Finally tested from the jump host:
```bash
curl -I http://stapp01:8086
```
**Explanation**
The issue was that Apache was not reachable on the custom port 8086.
The fix required:
* Ensuring Apache was configured to listen on port 8086.
* Restarting Apache after verifying configuration syntax.
* Checking for and resolving port conflicts.
* Allowing port 8086 in the firewall rules.



