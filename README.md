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

![Localhost output](<Screenshots/localhost_output.png>)

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

![EC2](<Screenshots/EC2-browser-output.png>)

### Screenshot: EC2 instance running with public IP (AWS Console)

![EC2](<Screenshots/EC2-instance-aws-console.png>)

### Screenshot: SSH terminal with docker build & run output

![Local GitBash](<Screenshots/Local-gitbash.png>)

![Local Git Bash](<Screenshots/local-gitbash.png>)

---

## Bonus Task 1: cloud-init Automation

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

![Cloud-init](<Screenshots/cloud-init-instance.png>)

![Cloud-init](<Screenshots/cloud-init-browser-output.png>)

---

## Bonus Task 2: IAM Role for S3 Access

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

### Screenshot: IAM role attached to EC2

![IAM Role](<Screenshots/creating-IAM-role.png>)

![IAM Role](<Screenshots/IAM-role-created.png>)

![IAM Role](<Screenshots/selecting-IAM-in-instance.png>)

![IAM Role](<Screenshots/IAM-successfully-attached.png>)

### Screenshot: `aws s3 ls` command working without keys

![AWS S3 ls](<Screenshots/aws-ls.png>)

---

## Bonus Task 3: deploy.sh Script

### Purpose

Automates clone → build → run on any server with Docker + Git

### Script (`deploy.sh`)

```bash
#!/bin/bash

# Stop any existing container using port 5000
docker ps -q --filter "publish=5000" | xargs -r docker stop

# Clone repo
if [ ! -d "devops_assignment" ]; then
    git clone https://github.com/NishitaNJ/devops_assignment.git
else
    cd devops_assignment && git pull && cd ..
fi

cd devops_assignment
docker build -t flask-ec2-app .
docker run -d -p 5000:5000 flask-ec2-app
```

### Screenshot 8: Terminal running deploy.sh script successfully

![deploy.sh](<Screenshots/deploy-output1.png>)

![deploy.sh](<Screenshots/deploy-output2.png>)

![deploy.sh](<Screenshots/deploy-output3.png>)

### Screenshot 9: App accessed after deploy script execution

![App accessed successfully](<Screenshots/app-access.png>)

---

## Instance Shutdown

All EC2 instances used were stopped 

---

## Author

**Nishita Joshi**
GitHub: [https://github.com/NishitaNJ](https://github.com/NishitaNJ)

---
