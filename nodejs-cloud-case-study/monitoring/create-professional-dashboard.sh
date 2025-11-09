#!/bin/bash

GRAFANA_URL="http://13.218.172.220:3001"
GRAFANA_USER="admin"
GRAFANA_PASS="admin123"

echo "Creating professional DevOps dashboard for interview..."

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

# Import professional dashboard
curl -X POST \
  -H "Content-Type: application/json" \
  -d @professional-dashboard.json \
  http://${GRAFANA_USER}:${GRAFANA_PASS}@13.218.172.220:3001/api/dashboards/db

echo "Professional dashboard created successfully!"
echo "Access at: http://13.218.172.220:3001"