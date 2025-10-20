#!/bin/bash
set -e

echo "Testing service communication"

# Wait for pods to be ready
sleep 15

# Test productpage to details service
echo "Testing ProductPage to Details service"
if kubectl exec deployment/productpage-v1 -- curl -s -f http://details:9080/details/0 > /dev/null 2>&1; then
    echo "PASS: ProductPage can reach Details service"
else
    echo "FAIL: ProductPage cannot reach Details service"
    exit 1
fi

# Test productpage to ratings service
echo "Testing ProductPage to Ratings service"
if kubectl exec deployment/productpage-v1 -- curl -s -f http://ratings:9080/ratings/0 > /dev/null 2>&1; then
    echo "PASS: ProductPage can reach Ratings service"
else
    echo "FAIL: ProductPage cannot reach Ratings service"
    exit 1
fi

# Test productpage to reviews service
echo "Testing ProductPage to Reviews service"
if kubectl exec deployment/productpage-v1 -- curl -s -f http://reviews:9080/reviews/0 > /dev/null 2>&1; then
    echo "PASS: ProductPage can reach Reviews service"
else
    echo "FAIL: ProductPage cannot reach Reviews service"
    exit 1
fi

echo "All service communication tests passed"
exit 0