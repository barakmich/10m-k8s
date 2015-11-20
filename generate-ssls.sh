#!/usr/bin/env bash
set -ex

export SSL_DIR=ssl
export CLUSTER_IP="10.3.0.1"
if [ -z "$1" ]; then
  echo "USAGE: $0 <controller_ip>"
  exit 1
fi

export NODE_IP=$1
mkdir -p $SSL_DIR
./lib/init-ssl-ca $SSL_DIR
./lib/init-ssl $SSL_DIR apiserver controller IP.1=$NODE_IP,IP.2=$CLUSTER_IP
./lib/init-ssl $SSL_DIR admin kube-admin
./lib/init-ssl $SSL_DIR worker kube-worker
