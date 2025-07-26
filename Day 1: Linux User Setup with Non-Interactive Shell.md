## Day 1: Linux User Setup with Non-Interactive Shell

###  Task Details  
Create a Linux User with a non-interactive shell  
> The System Admin Team of XfusionCorp Industries has installed a backup agent tool on all app servers. As per the tool’s requirements, they need to create a user with a non-interactive shell.

---

###  Solution  :

Logged into the target server using SSH:  
```bash
ssh tony@stapp01
```
Once logged in, created the user with the nologin shell:
```bash
sudo useradd -s /sbin/nologin ammar
```
Then verified the user was created successfully:

```bash
id ammar
```
#### Output: uid=1002(ammar) gid=1002(ammar) groups=1002(ammar)
**Explanation**
A **non-interactive shell** is a shell that does not allow the user to log in or interact with the system via a terminal session. This is commonly used for system or service accounts, like backup agents or automated processes, where login access is not needed.

In Linux, this is typically achieved by assigning a shell like:

**/sbin/nologin** (preferred on most Linux distros)

**/bin/false** (older method, works similarly)

These shells prevent the user from starting a command shell session.
