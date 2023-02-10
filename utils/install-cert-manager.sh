#!/usr/bin/bash

kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.8.0/cert-manager.crds.yaml

kubectl create namespace cert-manager

helm repo add cert-manager https://charts.jetstack.io

helm repo update

helm install cert-manager cert-manager \
    --repo https://charts.jetstack.io \
    --create-namespace --namespace cert-manager \
    --set installCRDs=true
