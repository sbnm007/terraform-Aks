#!/bin/bash
set -e

echo "Testing external access"

sleep 2

EXTERNAL_IP=$(kubectl get svc istio-ingressgateway -n istio-system -o jsonpath='{.status.loadBalancer.ingress[0].ip}')

if [ -z "$EXTERNAL_IP" ] || [ "$EXTERNAL_IP" = "null" ]; then
    echo "FAIL: External IP not assigned"
    exit 1
fi

echo "External IP: $EXTERNAL_IP"

# Test external access to productpage
if curl -f --connect-timeout 10 --max-time 30 "http://$EXTERNAL_IP/productpage" > /dev/null 2>&1; then
    echo "PASS: Application is accessible externally"
else
    echo "FAIL: Application not accessible externally"
    exit 1
fi

echo "External access test passed"
exit 0