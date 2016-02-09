#!/usr/bin/env bash
set -ex

HOSTOS=$(uname)
shopt -s expand_aliases

case "$HOSTOS" in
  Darwin|FreeBSD) alias sedinline="sed -i \"\"";;
  *) alias sedinline="sed -i";;
esac

if [ -z "$1" ]; then
  echo "USAGE: $0 <node_ip> <controller_ip> [<etcd_endpoint>]"
  exit 1
fi

if [ -z "$2" ]; then
  echo "USAGE: $0 <node_ip> <controller_ip> [<etcd_endpoint>]"
  exit 1
fi

export ETCD=$3
if [ -z "$3" ]; then
  export ETCD="http://$2:2379"
fi

export CONT="https://$2"
cp ./multi-node/generic/worker-install.sh /tmp/worker.sh
sedinline "s!export ETCD_ENDPOINTS=!export ETCD_ENDPOINTS=$ETCD!" /tmp/worker.sh
sedinline "s!CONTROLLER_ENDPOINT=!CONTROLLER_ENDPOINT=$CONT!" /tmp/worker.sh

scp /tmp/worker.sh core@$1:/tmp
scp ./ssl/kube-worker.tar core@$1:/tmp
ssh core@$1 'sudo mkdir -p /etc/kubernetes/ssl && sudo tar -C /etc/kubernetes/ssl -xf /tmp/kube-worker.tar'
ssh core@$1 'chmod +x /tmp/worker.sh && sudo /tmp/worker.sh'
echo "Doing a DO route hack...."
ssh core@$1 'sudo ip route del default via 10.16.0.1 dev eth0  proto static'
