#!/bin/bash

echo "Generating traffic for dashboard demo..."

# Generate continuous traffic to show metrics
for i in {1..100}; do
    curl -s http://13.218.172.220:3000/api/health > /dev/null
    curl -s http://13.218.172.220:3000/api/data > /dev/null
    curl -s http://13.218.172.220:3000/ > /dev/null
    curl -s http://13.218.172.220:9090/api/v1/query?query=up > /dev/null
    
    echo "Generated request batch $i/100"
    sleep 2
done

echo "Traffic generation complete!"