# 🚀 Complete Setup Guide - From AWS Instance to Automated Dashboard

## Phase 1: AWS Infrastructure Setup

### Step 1: Launch EC2 Instance

**AWS Console → EC2 → Launch Instance:**
- **AMI**: Ubuntu Server 22.04 LTS
- **Instance Type**: t3.medium (recommended for Jenkins)
- **Key Pair**: Create/Select your SSH key
- **Storage**: 20GB GP3

### Step 2: Configure Security Group

**AWS Console → EC2 → Security Groups → Select your SG:**

**Add Inbound Rules:**
- SSH (22) - Your IP
- Custom TCP (8080) - 0.0.0.0/0 (Jenkins)
- Custom TCP (3000) - 0.0.0.0/0 (App)
- Custom TCP (9090) - 0.0.0.0/0 (Prometheus)
- Custom TCP (3001) - 0.0.0.0/0 (Grafana)

## Phase 2: Connect to Server

### Step 3: Connect via SSH

```bash
cd Downloads
ssh -i your-key.pem ubuntu@YOUR_EC2_IP
```

## Phase 3: Software Installation

### Step 4: System Update

```bash
sudo apt update && sudo apt upgrade -y
```

### Step 5: Install Java (Required for Jenkins)

```bash
sudo apt install -y openjdk-21-jdk
java -version
```

### Step 6: Install Jenkins

```bash
# Add Jenkins repository key
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo tee /usr/share/keyrings/jenkins-keyring.asc > /dev/null

# Add Jenkins repository
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/ | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null

# Update and install Jenkins
sudo apt update
sudo apt install -y jenkins

# Start Jenkins
sudo systemctl start jenkins
sudo systemctl enable jenkins
sudo systemctl status jenkins
```

### Step 7: Install Docker

```bash
sudo apt install -y docker.io
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -aG docker jenkins
sudo systemctl restart jenkins
docker --version
```

### Step 8: Install Terraform

```bash
wget https://releases.hashicorp.com/terraform/1.6.0/terraform_1.6.0_linux_amd64.zip
sudo apt install unzip
unzip terraform_1.6.0_linux_amd64.zip
sudo mv terraform /usr/local/bin/
terraform --version
```

### Step 9: Install Ansible

```bash
sudo apt install -y ansible
ansible --version
```

### Step 10: Install Node.js

```bash
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt install -y nodejs
node --version
npm --version
```

### Step 11: Install AWS CLI

```bash
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
aws --version
```

## Phase 4: Configuration

### Step 12: Configure AWS CLI

```bash
aws configure
# Enter: Access Key, Secret Key, Region (us-east-1), Format (json)
aws sts get-caller-identity
```

### Step 13: Configure AWS for Jenkins User

```bash
# Switch to jenkins user
sudo su - jenkins

# Configure AWS CLI for jenkins user
aws configure
# Enter your AWS credentials

# Test connection
aws sts get-caller-identity

# Exit jenkins user
exit
```

### Step 14: Access Jenkins

```bash
# Get Jenkins password
sudo cat /var/lib/jenkins/secrets/initialAdminPassword

# Access Jenkins at:
# http://YOUR_EC2_IP:8080
```

### Step 15: Jenkins Initial Setup

1. **Unlock Jenkins** with password
2. **Install suggested plugins**
3. **Create admin user**
4. **Configure Jenkins URL**

### Step 16: Configure Jenkins Credentials

**Manage Jenkins → Credentials → System → Global credentials:**

**Add GitHub Credentials:**
- **Kind**: Username with password
- **Username**: Janhavi-j001
- **Password**: [GitHub token]
- **ID**: github-creds

**Add DockerHub Credentials:**
- **Kind**: Username with password
- **Username**: janhavi001
- **Password**: [DockerHub password]
- **ID**: dockerhub

### Step 17: Create Jenkins Pipeline

1. **New Item → Pipeline**
2. **Name**: nodejs-cloud-deployment
3. **Pipeline script from SCM**
4. **Repository**: https://github.com/Janhavi-j001/Case-study.git
5. **Script Path**: nodejs-cloud-case-study/Jenkinsfile

## Phase 5: Automated Dashboard Setup

### Step 18: Clone Repository
```bash
# Clone the project
git clone https://github.com/Janhavi-j001/Case-study.git
cd Case-study/nodejs-cloud-case-study
```

### Step 19: Make Scripts Executable
```bash
# Give execute permissions to all monitoring scripts
chmod +x monitoring/auto-setup-complete.sh
chmod +x monitoring/setup-grafana.sh
chmod +x monitoring/generate-traffic.sh
```

### Step 20: Run Automated Setup (One Command)
```bash
# This single command deploys everything
./monitoring/auto-setup-complete.sh
```

### Step 21: Generate Demo Traffic
```bash
# Start generating traffic for dashboard demonstration
./monitoring/generate-traffic.sh
```

## 🌐 Access URLs

After setup completion, access these URLs:

- **Main Application**: `http://YOUR_SERVER_IP:3000`
- **Grafana Dashboard**: `http://YOUR_SERVER_IP:3001`
  - Username: `admin`
  - Password: `admin123`
- **Prometheus**: `http://YOUR_SERVER_IP:9090`
- **Jenkins**: `http://YOUR_SERVER_IP:8080`

## 🔧 Manual Commands (If Needed)

### Install Docker (if not installed)
```bash
sudo apt update
sudo apt install -y docker.io
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -aG docker $USER
```

### Manual Container Deployment
```bash
# Build and run Node.js app
docker build -t nodejs-app .
docker run -d --name nodejs-app -p 3000:3000 nodejs-app

# Run Prometheus
docker run -d --name prometheus -p 9090:9090 \
  -v $(pwd)/monitoring/prometheus.yml:/etc/prometheus/prometheus.yml \
  prom/prometheus

# Run Grafana
docker run -d --name grafana -p 3001:3000 \
  -e GF_SECURITY_ADMIN_PASSWORD=admin123 \
  grafana/grafana
```

### Setup Grafana Dashboard Manually
```bash
# Wait for Grafana to start
sleep 30

# Add Prometheus data source and import dashboard
./monitoring/setup-grafana.sh
```

## 🚨 Troubleshooting

### Check Container Status
```bash
sudo docker ps -a
```

### View Container Logs
```bash
sudo docker logs nodejs-app
sudo docker logs prometheus
sudo docker logs grafana
```

### Restart Containers
```bash
sudo docker restart nodejs-app prometheus grafana
```

### Check Port Availability
```bash
sudo netstat -tlnp | grep -E ':(3000|3001|9090)'
```

## 🎯 Demo Commands for Interview

### 1. Quick Demo Setup
```bash
git clone https://github.com/Janhavi-j001/Case-study.git
cd Case-study/nodejs-cloud-case-study
chmod +x monitoring/auto-setup-complete.sh
./monitoring/auto-setup-complete.sh
```

### 2. Generate Traffic for Live Demo
```bash
./monitoring/generate-traffic.sh
```

### 3. Show Real-time Metrics
```bash
# Open these URLs in browser:
echo "Application: http://$(curl -s ifconfig.me):3000"
echo "Grafana: http://$(curl -s ifconfig.me):3001"
echo "Prometheus: http://$(curl -s ifconfig.me):9090"
```

## ⏱️ Expected Timeline
- **Infrastructure Setup**: 15-20 minutes
- **Software Installation**: 10-15 minutes
- **Jenkins Configuration**: 5-10 minutes
- **Repository Clone**: 30 seconds
- **Automated Setup**: 2-3 minutes
- **Dashboard Ready**: 3-4 minutes
- **Total**: 35-50 minutes

## 🎉 Success Indicators
- ✅ All containers running: `docker ps` shows 3 containers
- ✅ Application responds: `curl http://localhost:3000/api/health`
- ✅ Grafana accessible: Login page at port 3001
- ✅ Prometheus targets: Green status at port 9090/targets
- ✅ Dashboard data: Live metrics in Grafana dashboard
- ✅ Jenkins accessible: Login page at port 8080
- ✅ Pipeline ready: Jenkins job configured and runnable