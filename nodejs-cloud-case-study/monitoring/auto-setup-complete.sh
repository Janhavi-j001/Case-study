#!/bin/bash

echo "🚀 Starting complete automated monitoring setup..."

# Stop and remove existing containers
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

echo "📦 Starting containers..."

# Start Node.js app
sudo docker run -d \
  --name nodejs-app \
  --network monitoring \
  -p 3000:3000 \
  janhavi001/nodejs-cloud-app:cb1923e

# Start Prometheus
sudo docker run -d \
  --name prometheus \
  --network monitoring \
  -p 9090:9090 \
  -v /home/ubuntu/monitoring/prometheus.yml:/etc/prometheus/prometheus.yml \
  prom/prometheus:latest

# Start Grafana
sudo docker run -d \
  --name grafana \
  --network monitoring \
  -p 3001:3000 \
  -e GF_SECURITY_ADMIN_PASSWORD=admin123 \
  grafana/grafana:latest

echo "⏳ Waiting for services to start..."
sleep 60

echo "🎯 Setting up Grafana data source..."

# Add Prometheus data source
curl -X POST \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Prometheus",
    "type": "prometheus",
    "url": "http://prometheus:9090",
    "access": "proxy",
    "isDefault": true
  }' \
  http://admin:admin123@localhost:3001/api/datasources

echo "📊 Creating professional dashboard..."

# Create dashboard with API
curl -X POST \
  -H "Content-Type: application/json" \
  -d '{
    "dashboard": {
      "title": "DevOps Production Dashboard",
      "tags": ["devops", "production"],
      "timezone": "browser",
      "panels": [
        {
          "id": 1,
          "title": "Service Status",
          "type": "stat",
          "targets": [{"expr": "up", "refId": "A"}],
          "fieldConfig": {
            "defaults": {
              "mappings": [
                {"options": {"0": {"text": "DOWN", "color": "red"}}, "type": "value"},
                {"options": {"1": {"text": "UP", "color": "green"}}, "type": "value"}
              ]
            }
          },
          "gridPos": {"h": 6, "w": 6, "x": 0, "y": 0}
        },
        {
          "id": 2,
          "title": "HTTP Requests",
          "type": "stat",
          "targets": [{"expr": "sum(prometheus_http_requests_total)", "refId": "A"}],
          "gridPos": {"h": 6, "w": 6, "x": 6, "y": 0}
        },
        {
          "id": 3,
          "title": "Memory Usage",
          "type": "stat",
          "targets": [{"expr": "go_memstats_alloc_bytes / 1024 / 1024", "refId": "A"}],
          "fieldConfig": {"defaults": {"unit": "decbytes"}},
          "gridPos": {"h": 6, "w": 6, "x": 12, "y": 0}
        },
        {
          "id": 4,
          "title": "Request Rate",
          "type": "timeseries",
          "targets": [{"expr": "rate(prometheus_http_requests_total[5m])", "refId": "A"}],
          "fieldConfig": {"defaults": {"unit": "reqps"}},
          "gridPos": {"h": 8, "w": 12, "x": 0, "y": 6}
        },
        {
          "id": 5,
          "title": "Memory Trend",
          "type": "timeseries",
          "targets": [{"expr": "go_memstats_alloc_bytes", "refId": "A"}],
          "fieldConfig": {"defaults": {"unit": "bytes"}},
          "gridPos": {"h": 8, "w": 12, "x": 12, "y": 6}
        }
      ],
      "time": {"from": "now-15m", "to": "now"},
      "refresh": "5s"
    }
  }' \
  http://admin:admin123@localhost:3001/api/dashboards/db

echo "🔥 Generating traffic for demo..."

# Generate traffic in background
for i in {1..50}; do
    curl -s http://localhost:3000/api/health > /dev/null &
    curl -s http://localhost:3000/api/data > /dev/null &
    curl -s http://localhost:9090/api/v1/query?query=up > /dev/null &
    sleep 1
done

echo "✅ Setup complete!"
echo ""
echo "🎯 Access your dashboard:"
echo "   Grafana: http://13.218.172.220:3001"
echo "   Login: admin / admin123"
echo ""
echo "📊 Your professional dashboard is ready for interview!"