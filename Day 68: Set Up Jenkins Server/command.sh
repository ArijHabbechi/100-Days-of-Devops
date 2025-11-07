yum update -y
yum install -y wget
#Install jenkins for fedora with stable version base on the documentation
sudo wget -O /etc/yum.repos.d/jenkins.repo \
https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
sudo dnf upgrade -y
# Add required dependencies for the jenkins package
sudo dnf install fontconfig java-21-openjdk -y
sudo dnf install jenkins -y
sudo systemctl daemon-reload
#Start Jenkins server
sudo systemctl enable --now jenkins
