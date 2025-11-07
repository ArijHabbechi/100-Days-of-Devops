# Jenkins Installation and Setup Task

## Task Description

The DevOps team at xFusionCorp Industries is initiating the setup of CI/CD pipelines and has decided to utilize Jenkins as their server. Execute the task according to the provided requirements:

1. Install Jenkins on the jenkins server using the yum utility only, and start its service.

   If you face a timeout issue while starting the Jenkins service, refer to this.
2. Jenkin's admin user name should be **theadmin**, password should be **Adm!n321**, full name should be **Kareem** and email should be **kareem@jenkins.stratos.xfusioncorp.com**.

### Note:

1. To access the jenkins server, connect from the jump host using the root user with the password **S3curePass**.
2. After Jenkins server installation, click the Jenkins button on the top bar to access the Jenkins UI and follow on-screen instructions to create an admin user.

---

## Solution
### 0. Connect to Jenkins Server
```bash
ssh root@jenkins
```
### 1. Run the command.sh file

```bash
./command.sh
```

### 2. Login into Jenkins UI and Setup Jenkins

1. Paste the initial password.
2. Install suggested plugins (it will take some time).
3. Continue (skip retry if prompted).
4. Set the following details:
   - **Username:** theadmin
   - **Password:** Adm!n321
   - **Confirm Password:** Adm!n321
   - **Full Name:** Kareem
   - **Email:** kareem@jenkins.stratos.xfusioncorp.com
5. Click **Save and Continue > Save and Finish**.
6. Click **Start Jenkins**.
7. **Done.**
