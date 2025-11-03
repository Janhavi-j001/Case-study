#!/bin/bash
echo "Building Node.js application..."
cd backend
npm install
cd ..
docker build -t nodejs-cloud-app .