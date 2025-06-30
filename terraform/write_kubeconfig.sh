#!/bin/bash

KUBECONFIG_CONTENT=$1

mkdir -p ~/.kube

echo "$KUBECONFIG_CONTENT" > ~/.kube/config
chmod 600 ~/.kube/config
