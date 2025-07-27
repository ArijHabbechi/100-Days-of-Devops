### Task Details  
As part of the temporary assignment to the Nautilus project, a developer named **jim** requires access for a limited duration. To ensure smooth access management, a temporary user account with an expiry date is needed.  

> Create a user named `jim` on **App Server 2** in **Stratos Datacenter**. Set the expiry date to **2024-02-17**, ensuring the username is created in lowercase as per standard protocol.

---

###  Solution  

Logged into App Server 2:
```bash
ssh steve@stapp02
```

Switched to root user:
```bash
sudo su
```

Created the user `jim` with an expiry date:
```bash
useradd -e 2024-02-17 jim
```

---

### Explanation  

To create a user with a temporary login period, we use the `-e` flag with the `useradd` command:

```
sudo useradd -e YYYY-MM-DD <username>
```

- `-e`: Sets the **account expiration date** in `YYYY-MM-DD` format.
- Once the date is reached, the user account will be disabled automatically.
- Useful for: temporary developers, contractors, or short-term projects.

---

### 🧠 BONUS :  Common `useradd` Options  

```
sudo useradd [options] <username>
```
| Option | Example | Purpose |
|--------|---------|---------|
| `-e YYYY-MM-DD` | `-e 2024-12-31` | Set account expiry date (disables login afterward) |
| `-f DAYS` | `-f 7` | Account expires X days **after password expires** (use `-1` to disable) |
| `-s /sbin/nologin` | `-s /sbin/nologin` | Prevents shell login (used for system/service accounts) |
| `-m` | `-m` | Create a home directory automatically |
| `-d /custom/home` | `-d /srv/devuser` | Set custom home directory location |
| `-c "comment"` | `-c "DevOps Engineer"` | Add user description or real name (useful in auditing) |
| `-u UID` | `-u 1501` | Set specific UID for integration with LDAP/AD/policy |
| `-g GROUP` | `-g devs` | Assign primary group |
| `-G group1,group2` | `-G docker,sudo` | Assign to secondary groups |
| `-p ENCRYPTED_PASS` | `-p $(openssl passwd -1 'yourpass')` | Set initial password (must be encrypted) |
| `-K KEY=VALUE` | `-K UID_MIN=1500` | Override `/etc/login.defs` default settings |
| `--shell /bin/bash` | `--shell /sbin/nologin` | Explicitly set shell (same as `-s`) |
| `--no-create-home` | `--no-create-home` | Prevent creation of home directory (system/service users) |
| `--system` | `--system` | Create a system account (UID < 1000, no expiry, no login) |

---

### 🔐 Tips for Secure User Management  

- Use `nologin` for service or bot accounts.
- Always apply an expiry date (`-e`) for temporary users.
- Use `-f` to enforce automatic lock after password expiry.
- Add users to proper groups using `-G` to avoid giving full `sudo` unless needed.
- Regularly audit `/etc/passwd`, `/etc/shadow`, and `/etc/group` for stale or unnecessary accounts.


