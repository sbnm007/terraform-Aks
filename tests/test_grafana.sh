#!/bin/bash
set -e

echo "Testing Grafana access"

GRAFANA_IP=$(kubectl get svc grafana-external -n istio-system -o jsonpath='{.status.loadBalancer.ingress[0].ip}' 2>/dev/null || echo "")

if [ -z "$GRAFANA_IP" ] || [ "$GRAFANA_IP" = "null" ] || [ "$GRAFANA_IP" = "pending" ]; then
    echo "FAIL: Grafana external IP not assigned"
    exit 1
fi

echo "Grafana IP: $GRAFANA_IP"

if curl -f --max-time 15 "http://$GRAFANA_IP:3000" > /dev/null 2>&1; then
    echo "PASS: Grafana accessible at http://$GRAFANA_IP:3000"
else
    echo "FAIL: Grafana not responding"
    exit 1
fi

echo "Grafana access test passed"
exit 0