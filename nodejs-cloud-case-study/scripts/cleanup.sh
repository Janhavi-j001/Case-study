#!/bin/bash
echo "Cleaning up resources..."
kubectl delete -f k8s/
docker system prune -f