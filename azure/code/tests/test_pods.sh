#!/bin/bash
set -e

echo "Testing pod status and sidecar injection"

# Test 1: Check all Bookinfo pods are running
echo "Checking Bookinfo pods status"

for deployment in productpage-v1 details-v1 ratings-v1 reviews-v1 reviews-v2 reviews-v3; do
    app_name=${deployment%-*}
    pod_status=$(kubectl get pods -l app=$app_name --no-headers | head -1 | awk '{print $3}')
    
    if [ "$pod_status" = "Running" ]; then
        echo "PASS: $deployment pod is running"
    else
        echo "FAIL: $deployment pod status is $pod_status"
        exit 1
    fi
done

# Test 2: Check Istio sidecar injection
echo "Checking Istio sidecar injection"

for deployment in productpage-v1 details-v1 ratings-v1 reviews-v1 reviews-v2 reviews-v3; do
    app_name=${deployment%-*}
    sidecar_count=$(kubectl get pod -l app=$app_name -o jsonpath='{.items[0].spec.containers[*].name}' | tr ' ' '\n' | grep -c istio-proxy || echo "0")
    
    if [ "$sidecar_count" -gt 0 ]; then
        echo "PASS: $deployment has Istio sidecar"
    else
        echo "FAIL: $deployment missing Istio sidecar"
        exit 1
    fi
done

echo "All pod tests passed"
exit 0