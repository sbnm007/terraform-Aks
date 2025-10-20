#!/bin/bash
set -e

echo "Testing Kiali access"

KIALI_IP=$(kubectl get svc kiali-external -n istio-system -o jsonpath='{.status.loadBalancer.ingress[0].ip}' 2>/dev/null || echo "")

if [ -z "$KIALI_IP" ] || [ "$KIALI_IP" = "null" ] || [ "$KIALI_IP" = "pending" ]; then
    echo "FAIL: Kiali external IP not assigned"
    exit 1
fi

echo "Kiali IP: $KIALI_IP"

if curl -f --max-time 15 "http://$KIALI_IP:20001" > /dev/null 2>&1; then
    echo "PASS: Kiali accessible at http://$KIALI_IP:20001"
else
    echo "FAIL: Kiali not responding"
    exit 1
fi

echo "Kiali access test passed"
exit 0