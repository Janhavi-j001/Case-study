#!/bin/bash

echo "Setting up complete monitoring stack..."

# Stop existing containers
sudo docker stop prometheus grafana nodejs-app 2>/dev/null || true
sudo docker rm prometheus grafana nodejs-app 2>/dev/null || true

# Create monitoring network
sudo docker network create monitoring 2>/dev/null || true

# Create prometheus config
sudo mkdir -p /home/ubuntu/monitoring
sudo tee /home/ubuntu/monitoring/prometheus.yml > /dev/null <<EOF
global:
  scrape_interval: 15s

scrape_configs:
  - job_name: 'prometheus'
    static_configs:
      - targets: ['localhost:9090']
EOF

# Start containers with network
echo "Starting Node.js app..."
sudo docker run -d \
  --name nodejs-app \
  --network monitoring \
  -p 3000:3000 \
  janhavi001/nodejs-cloud-app:cb1923e

echo "Starting Prometheus..."
sudo docker run -d \
  --name prometheus \
  --network monitoring \
  -p 9090:9090 \
  -v /home/ubuntu/monitoring/prometheus.yml:/etc/prometheus/prometheus.yml \
  prom/prometheus:latest

echo "Starting Grafana..."
sudo docker run -d \
  --name grafana \
  --network monitoring \
  -p 3001:3000 \
  -e GF_SECURITY_ADMIN_PASSWORD=admin123 \
  grafana/grafana:latest

echo "Waiting for services to start..."
sleep 60

echo "All services started!"
echo "Access URLs:"
echo "- Node.js App: http://13.218.172.220:3000"
echo "- Prometheus: http://13.218.172.220:9090" 
echo "- Grafana: http://13.218.172.220:3001 (admin/admin123)"