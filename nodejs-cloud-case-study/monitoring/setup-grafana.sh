#!/bin/bash

# Grafana setup script
GRAFANA_URL="http://13.218.172.220:3001"
GRAFANA_USER="admin"
GRAFANA_PASS="admin123"

echo "Setting up Grafana dashboards and data sources..."

# Wait for Grafana to be ready
sleep 30

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
  http://${GRAFANA_USER}:${GRAFANA_PASS}@13.218.172.220:3001/api/datasources

# Create dashboard
curl -X POST \
  -H "Content-Type: application/json" \
  -d '{
    "dashboard": {
      "title": "DevOps Monitoring Dashboard",
      "panels": [
        {
          "id": 1,
          "title": "Service Status",
          "type": "stat",
          "targets": [{"expr": "up", "refId": "A"}],
          "gridPos": {"h": 8, "w": 12, "x": 0, "y": 0}
        },
        {
          "id": 2,
          "title": "Memory Usage", 
          "type": "timeseries",
          "targets": [{"expr": "go_memstats_alloc_bytes", "refId": "A"}],
          "gridPos": {"h": 8, "w": 12, "x": 12, "y": 0}
        },
        {
          "id": 3,
          "title": "HTTP Requests",
          "type": "timeseries", 
          "targets": [{"expr": "prometheus_http_requests_total", "refId": "A"}],
          "gridPos": {"h": 8, "w": 24, "x": 0, "y": 8}
        }
      ],
      "time": {"from": "now-5m", "to": "now"},
      "refresh": "5s"
    }
  }' \
  http://${GRAFANA_USER}:${GRAFANA_PASS}@13.218.172.220:3001/api/dashboards/db

echo "Grafana setup complete!"