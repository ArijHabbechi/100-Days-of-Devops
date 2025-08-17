
### Task Details  
>We have one of our websites up and running on the Nautilus infrastructure in **Stratos Datacenter**.  
The security team raised a concern that Apache’s port **3003** is currently open for all since there is no firewall installed on the app hosts.  

To improve security, the following requirements were defined:  

1. Install `iptables` and all its dependencies on each app host.  
2. Block incoming traffic on port **3003** for everyone **except the LBR host (172.16.238.14)**.  
3. Ensure firewall rules **persist after reboot**.  

---

### Solution  

Logged into each app host and switched to root:  
```bash
ssh <user>@<app-host>
sudo -i
```
Updated system packages and installed iptables:

```bash
yum update -y
yum install -y iptables iptables-services
```
Enabled and started iptables service:

```bash
systemctl enable iptables
systemctl start iptables
```
Added firewall rules:

```bash
# Allow only LBR host access to port 3003
iptables -R INPUT 5 -p tcp --dport 3003 -s 172.16.238.14 -j ACCEPT

# Drop all other traffic to port 3003
iptables -A INPUT -p tcp --dport 3003 -j DROP
```
Saved rules to persist after reboot:

```bash
service iptables save
iptables-save > /etc/sysconfig/iptables
```

**Explanation**
* We used iptables to control access to Apache’s custom port 3003.
- First rule (-R INPUT 5) allows traffic only from the LBR host (172.16.238.14).
* Second rule (-A INPUT) drops all other connections on port 3003.

* **Using service iptables save and iptables-save > /etc/sysconfig/iptables ensures rules survive system reboots.**

* **Enabling the iptables service guarantees the firewall is active on startup.**

### 🧠 BONUS : iptables Basics

| Command                                | Purpose                                       |
|----------------------------------------|-----------------------------------------------|
| iptables -A INPUT ...                  | Append a rule to the INPUT chain              |
| iptables -I INPUT <num> ...            | Insert a rule at a specific position          |
| iptables -R INPUT <num> ...            | Replace a rule at a specific position         |
| iptables -D INPUT <num>                | Delete a rule at a specific position          |
| iptables -L -n -v                      | List all rules with counters                  |
| service iptables save                  | Save active rules to disk                     |
| iptables-save > /etc/sysconfig/iptables| Explicitly persist rules on CentOS/RHEL       |


### 🔐 Tips for Secure Firewall Management
* Always allow required IPs first, then add the DROP rule at the end.
* Use iptables -L -n -v to check rule order and counters.
* Be careful with DROP rules — blocking SSH (22) can lock you out. 
