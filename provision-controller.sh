#!/usr/bin/env bash
set -ex

if [ -z "$1" ]; then
  echo "USAGE: $0 <node_ip> [<etcd_endpoint>]"
  exit 1
fi

export ETCD=$2
if [ -z "$2" ]; then
  export ETCD="http://$1:2379"
fi


cp ./multi-node/generic/controller-install.sh /tmp/ctrl.sh
sed -i "s!export ETCD_ENDPOINTS=!export ETCD_ENDPOINTS=$ETCD!" /tmp/ctrl.sh
sed -i "/register-node=false/d" /tmp/ctrl.sh

scp /tmp/ctrl.sh core@$1:/tmp
scp ./ssl/controller.tar core@$1:/tmp
ssh core@$1 'sudo mkdir -p /etc/kubernetes/ssl && sudo tar -C /etc/kubernetes/ssl -xf /tmp/controller.tar'
ssh core@$1 'chmod +x /tmp/ctrl.sh && sudo /tmp/ctrl.sh'
echo "Doing a DO route hack...."
ssh core@$1 'sudo ip route del default via 10.16.0.1 dev eth0  proto static'
