#!/bin/bash
set -e

echo "Testing Prometheus internal access"

if kubectl exec -n istio-system deployment/prometheus -- wget -q -O- http://localhost:9090/api/v1/query?query=up 2>/dev/null | grep -q "success"; then
    echo "PASS: Prometheus collecting metrics"
else
    echo "FAIL: Prometheus metrics collection issue"
    exit 1
fi

echo "Prometheus access test passed"
exit 0