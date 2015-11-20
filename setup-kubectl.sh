#!/usr/bin/env bash

set -ex

if [ -z "$1" ]; then
  echo "USAGE: $0 <cluster_name> <controller_ip>"
  exit 1
fi

if [ -z "$2" ]; then
  echo "USAGE: $0 <cluster_name> <controller_ip>"
  exit 1
fi
kubectl config set-cluster $1 --server=https://$2 --certificate-authority=$PWD/ssl/ca.pem
kubectl config set-credentials $1-admin --certificate-authority=$PWD/ssl/ca.pem --client-key=$PWD/ssl/admin-key.pem --client-certificate=$PWD/ssl/admin.pem
kubectl config set-context $1 --cluster=$1 --user=$1-admin
kubectl config use-context $1
