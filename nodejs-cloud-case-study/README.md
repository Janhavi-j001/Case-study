# Node.js Cloud DevOps Case Study

A complete DevOps pipeline demonstrating CI/CD, Infrastructure as Code, containerization, and monitoring for a Node.js application.

## 🏗️ Architecture Overview

```
GitHub → Jenkins → Docker Hub → Terraform → AWS EC2 → Ansible → Monitoring
```

## 🚀 Features

- **CI/CD Pipeline**: Automated build, test, and deployment with Jenkins
- **Infrastructure as Code**: AWS infrastructure provisioning with Terraform
- **Containerization**: Docker multi-stage builds for optimized production images
- **Configuration Management**: Ansible playbooks for application deployment
- **Monitoring Stack**: Prometheus and Grafana for metrics and visualization
- **Professional UI**: Modern DevOps platform dashboard with health monitoring

## 📁 Project Structure

```
nodejs-cloud-case-study/
├── backend/                 # Node.js Express API
│   ├── app.js              # Main application
│   ├── package.json        # Dependencies
│   └── healthcheck.js      # Health check endpoint
├── frontend/               # Professional DevOps UI
│   ├── index.html         # Dashboard interface
│   ├── style.css          # Modern styling
│   └── script.js          # API integration
├── terraform/             # Infrastructure as Code
│   ├── main.tf           # AWS resources
│   ├── provider.tf       # AWS provider config
│   └── outputs.tf        # Infrastructure outputs
├── ansible/              # Configuration Management
│   └── deploy.yml       # Deployment playbook
├── k8s/                 # Kubernetes manifests
│   ├── deployment.yml   # App deployment
│   └── service.yml      # Load balancer service
├── Dockerfile           # Multi-stage container build
└── Jenkinsfile         # CI/CD pipeline definition
```

## 🛠️ Technology Stack

### Backend
- **Node.js 18** - Runtime environment
- **Express.js** - Web framework
- **Helmet** - Security middleware
- **Rate Limiting** - API protection

### DevOps Tools
- **Jenkins** - CI/CD automation
- **Docker** - Containerization
- **Terraform** - Infrastructure provisioning
- **Ansible** - Configuration management
- **AWS EC2** - Cloud infrastructure

### Monitoring
- **Prometheus** - Metrics collection
- **Grafana** - Visualization dashboard
- **Health Checks** - Application monitoring

## 🚦 CI/CD Pipeline

### Pipeline Stages

1. **Clone Repository** - Fetch latest code from GitHub
2. **Install Dependencies** - Handled during Docker build
3. **Run Tests** - Automated testing (configured for demo)
4. **Docker Build & Push** - Create and publish container images
5. **Terraform Deploy** - Provision AWS infrastructure
6. **Wait for Server** - Ensure EC2 instance is ready
7. **Ansible Deploy** - Deploy application and monitoring stack

### Automated Triggers
- **SCM Polling** - Checks for changes every 2 minutes
- **Webhook Support** - GitHub webhook integration available

## 🏃‍♂️ Quick Start

### Prerequisites
- AWS Account with appropriate permissions
- Jenkins server with required plugins
- Docker Hub account
- GitHub repository access

### Setup Instructions

1. **Configure Jenkins Credentials**
   ```bash
   # Add these credentials in Jenkins:
   - github-creds: GitHub access token
   - dockerhub: Docker Hub username/password
   ```

2. **Configure AWS Credentials**
   ```bash
   # On Jenkins server:
   sudo su - jenkins
   aws configure
   # Enter AWS Access Key, Secret Key, Region (us-east-1)
   ```

3. **Create Jenkins Pipeline**
   - New Item → Pipeline
   - Pipeline script from SCM
   - Repository: `https://github.com/Janhavi-j001/Case-study.git`
   - Script Path: `nodejs-cloud-case-study/Jenkinsfile`

4. **Enable SCM Polling**
   - Build Triggers → Poll SCM
   - Schedule: `H/2 * * * *`

### Manual Deployment

```bash
# Clone repository
git clone https://github.com/Janhavi-j001/Case-study.git
cd Case-study/nodejs-cloud-case-study

# Build and run locally
docker build -t nodejs-cloud-app .
docker run -p 3000:3000 nodejs-cloud-app

# Deploy infrastructure
cd terraform
terraform init
terraform plan
terraform apply

# Deploy application
cd ../ansible
ansible-playbook -i inventory deploy.yml
```

## 🌐 Application Endpoints

### Main Application
- **Health Check**: `http://your-server:3000/api/health`
- **API Data**: `http://your-server:3000/api/data`
- **Dashboard**: `http://your-server:3000`

### Monitoring
- **Prometheus**: `http://your-server:9090`
- **Grafana**: `http://your-server:3001`
  - Username: `admin`
  - Password: `admin123`

## 📊 Monitoring & Observability

### Metrics Available
- Application health status
- HTTP request metrics
- System resource usage
- Container performance

### Grafana Dashboards
- Real-time application metrics
- Infrastructure monitoring
- Custom business metrics
- Alert configurations

## 🔧 Configuration

### Environment Variables
```bash
NODE_ENV=production
PORT=3000
AWS_DEFAULT_REGION=us-east-1
```

### Docker Configuration
- Multi-stage build for optimization
- Non-root user for security
- Health checks included
- Production-ready setup

### Security Features
- Helmet.js security headers
- Rate limiting protection
- Non-root container execution
- SSH key-based authentication

## 🚨 Troubleshooting

### Common Issues

**Docker Permission Denied**
```bash
sudo usermod -aG docker jenkins
sudo systemctl restart jenkins
```

**AWS Credentials Not Found**
```bash
aws configure
aws sts get-caller-identity
```

**APT Lock Issues**
- Ansible playbook includes automatic APT lock handling
- Waits for system updates to complete

**Server Not Ready**
- Pipeline includes robust server readiness checks
- Automatic retry with exponential backoff

## 📈 Performance Optimizations

- **Multi-stage Docker builds** - Reduced image size
- **Caching strategies** - Faster builds
- **Resource limits** - Kubernetes resource management
- **Health checks** - Automatic recovery

## 🔄 Continuous Improvement

### Planned Enhancements
- Automated testing integration
- Blue-green deployment strategy
- Advanced monitoring alerts
- Security scanning integration

## 📝 Contributing

1. Fork the repository
2. Create feature branch (`git checkout -b feature/amazing-feature`)
3. Commit changes (`git commit -m 'Add amazing feature'`)
4. Push to branch (`git push origin feature/amazing-feature`)
5. Open Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👥 Authors

- **Janhavi Jadhav** - *Initial work* - [Janhavi-j001](https://github.com/Janhavi-j001)

## 🙏 Acknowledgments

- AWS for cloud infrastructure
- Jenkins community for CI/CD tools
- Docker for containerization platform
- Terraform for infrastructure automation
- Ansible for configuration management

---

**Built with ❤️ for DevOps Excellence**