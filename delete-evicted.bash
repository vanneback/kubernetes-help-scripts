#!/bin/bash
set -e -o pipefail
if [[ ! $# -eq 1 ]]; then
    echo "Arguments must be equal to 1"
    echo "Usage $0 <namespace>"
    exit 1
fi
namespace=$1
kubectl get ns $namespace > /dev/null
kubectl get pods -n $namespace | grep Evicted | awk '{print $1}' | xargs kubectl delete pod --dry-run=client -n $namespace

while true; do
    read -p "Do you want to delete these resources? [yY]: " yn
    case $yn in
        [Yy]* ) kubectl get pods -n $namespace | grep Evicted | awk '{print $1}' | xargs kubectl delete pod -n $namespace ; break;;
        [Nn]* ) exit;;
        * ) echo "Please answer yes or no.";;
    esac
done

