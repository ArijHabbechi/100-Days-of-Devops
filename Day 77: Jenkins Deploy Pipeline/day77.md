## 1. Install Required Jenkins Plugins

From the Jenkins UI:

1. Update plugins.
2. Under **Available plugins**, install:

   - **Git plugin**
   - **SSH Agent plugin**
   - **Pipeline plugin**

3. Restart Jenkins to apply the changes.

---

## 2. Install Java 21 on the Storage Server

The Jenkins agent on the Storage Server requires a compatible Java runtime.

On the Storage Server:

```bash
sudo dnf install -y java-21-openjdk
```


## 3. Configure Storage Server as Jenkins Agent
**In Jenkins**:

Go to Manage Jenkins → Nodes and Clouds → New Node.

Create a new Permanent Agent with:

* Node name: Storage Server

* Remote root directory: /var/www/html/workspace

* Labels: ststor01



**On the Storage Server**:

* Run the generated command to bring the agent online.

* Confirm in Jenkins that the node status is online.

## 4. Configure Credentials for SSH 
**In Jenkins**:

* Go to Manage Jenkins → Credentials.

* Add a new credential for SSH access to the Storage Server.


## 5. Adjust Folder Permissions on the Storage Server
To allow the Jenkins agent to write into the web root:

```bash
sudo chown -R natasha:natasha /var/www/html
sudo chmod -R 755 /var/www/html
```


## 6. Create Jenkins Pipeline Job
**In Jenkins**:

* Click New Item.

Enter a job name, ( *xfusion-webapp-job* ).

* Select Pipeline (not Multibranch Pipeline).


### 6.1. Configure the Pipeline

*For this setup, the pipeline script is stored in the Jenkinsfile*  
