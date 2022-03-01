#!/bin/bash

echo "Install net-tools (ifconfig cmd)"
sudo yum install net-tools -y

echo "Install KS3 on controller mode"
### https://tferdinand.net/creer-un-cluster-kubernetes-local-avec-vagrant/
### https://rancher.com/docs/k3s/latest/en/installation/install-options/server-config/
curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="--write-kubeconfig-mode=644 --bind-address=192.168.42.110 --node-ip=192.168.42.110 --tls-san $(hostname) --advertise-address=192.168.42.110" sh -

echo "Copy controler node-token to /vagrant/scripts/node-token"
sudo cp /var/lib/rancher/k3s/server/node-token /vagrant/scripts/

echo "Add k alias for all users"
### https://askubuntu.com/questions/610052/how-can-i-preset-aliases-for-all-users
echo "alias k='kubectl'" >> /etc/profile.d/00-aliases.sh

