#!/bin/bash

# This script scans your Kubernetes cluster for vulnerabilities using Trivy.

# Ensure you have Trivy installed:
# https://aquasecurity.github.io/trivy/v0.30.4/getting-started/installation/

# Ensure you have kubectl configured to point to your cluster.

echo "Scanning Kubernetes cluster for vulnerabilities..."

trivy k8s --report summary cluster

echo "\nScan complete. For a detailed report, run: trivy k8s --report all cluster"
