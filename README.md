# DevOps Assignment: Dockerized Flask App Deployment on AWS EC2

## Project Overview

The project demonstrates end-to-end deployment of a containerized Flask web application on AWS EC2. It covers Dockerization, manual and automated cloud deployment using cloud-init, and DevOps automation scripts. Bonus tasks include cloud-init provisioning, IAM integration, and deploy script creation.

---

## Tools & Technologies Used

* **Python 3.9 + Flask** – Minimal web app
* **Docker** – Containerization
* **Git & GitHub** – Version control
* **AWS EC2 (Ubuntu 22.04 LTS)** – Cloud platform
* **cloud-init** – Boot-time automation
* **IAM Role + AWS CLI** – Secure S3 access

---

## Local Docker Setup

### Prerequisites

* [Docker Desktop](https://www.docker.com/products/docker-desktop)
* [Git](https://git-scm.com/downloads)

### Steps

```bash
git clone https://github.com/NishitaNJ/devops_assignment.git
cd devops_assignment
docker build -t flask-ec2-app .
docker run -d -p 5000:5000 flask-ec2-app
```

Visit: [http://localhost:5000](http://localhost:5000)

![Localhost output](<Screenshot (384).png>)

---

## Manual EC2 Deployment

### EC2 Setup

* AMI: Ubuntu 24.04 LTS (Free Tier)
* Instance Type: `t2.micro`
* Inbound Ports: 22 (SSH), 5000 (App Access)
* SSH using `.pem` key

### Manual Steps

```bash
sudo apt update
sudo apt install -y docker.io git

# Clone & Run
git clone https://github.com/NishitaNJ/devops_assignment.git
cd devops_assignment
docker build -t flask-ec2-app .
docker run -d -p 5000:5000 flask-ec2-app
```

Visit: `http://<EC2-PUBLIC-IP>:5000`

![EC2 Browser output](<Screenshot (385).png>)

### 📸 Screenshot 1: EC2 instance running with public IP (AWS Console)

![EC2 Instance running in AWS Console](<Screenshot (405)-1.png>)

### 📸 Screenshot 2: SSH terminal with docker build & run output

![Local GitBash](<Screenshot (388).png>)

![Local Git Bash](<Screenshot (386).png>)

### 📸 Screenshot 3: Browser showing the Flask app from EC2 IP



---

## ✨ Bonus Task 1: cloud-init Automation

### cloud-init.yaml

```yaml
#cloud-config
package_update: true
packages:
  - docker.io
  - git
runcmd:
  - systemctl start docker
  - systemctl enable docker
  - usermod -aG docker ubuntu
  - su - ubuntu -c "git clone https://github.com/NishitaNJ/devops_assignment.git"
  - su - ubuntu -c "cd devops_assignment && docker build -t flask-ec2-app ."
  - su - ubuntu -c "docker run -d -p 5000:5000 flask-ec2-app"
```

### EC2 Launch with User Data:

* Paste the script under **Advanced details > User Data**
* App runs at boot without SSH

![Cloud-init Instance Running](<Screenshot (391).png>)

![Cloud-init browser output](<Screenshot (392).png>)

---

## ✨ Bonus Task 2: IAM Role for S3 Access

### IAM Role Setup

* Create role: **EC2-S3ReadOnly-Role**
* Attach policy: `AmazonS3ReadOnlyAccess`
* Assign role to EC2 instance

### Test on EC2

```bash
sudo apt install unzip -y
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
aws s3 ls
```

### 📸 Screenshot 6: IAM role attached to EC2

![Creating IAM Role](<Screenshot (393).png>)

![Created IAM Role](<Screenshot (394).png>)

![Selecting IAM role in the instance](<Screenshot (396).png>)

![IAM Role successfully attached](<Screenshot (397).png>)

### 📸 Screenshot 7: `aws s3 ls` command working without keys

![AWS S3 ls](<Screenshot (398).png>)

---

## ✨ Bonus Task 3: deploy.sh Script

### Purpose

Automates clone → build → run on any server with Docker + Git

### Script (`deploy.sh`)

```bash
#!/bin/bash

# Stop any existing container using port 5000
docker ps -q --filter "publish=5000" | xargs -r docker stop

# Clone repo
if [ ! -d "devops-assignment" ]; then
    git clone https://github.com/NishitaNJ/devops_assignment.git
else
    cd devops_assignment && git pull && cd ..
fi

cd devops_assignment
docker build -t flask-ec2-app .
docker run -d -p 5000:5000 flask-ec2-app
```

### 📸 Screenshot 8: Terminal running deploy.sh script successfully

![deploy.sh output](<Screenshot (401).png>)

![deploy.sh](<Screenshot (402).png>)

![deploy.sh](<Screenshot (403).png>)

### 📸 Screenshot 9: App accessed after deploy script execution

![App accessed successfully](<Screenshot (404).png>)

---

## Instance Shutdown

All EC2 instances used were stopped 

---

## 🙋‍♀️ Author

**Your Name**
GitHub: [https://github.com/NishitaNJ](https://github.com/NishitaNJ)

---
