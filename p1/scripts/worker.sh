#!/bin/bash

echo "Install net-tools (ifconfig cmd)"
sudo yum install net-tools -y

echo "Install KS3 on worker mode"
### https://rancher.com/docs/k3s/latest/en/quick-start/
curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="agent --server https://192.168.42.110:6443 --token-file /vagrant/scripts/node-token --node-ip=192.168.42.111" sh -

echo "Add k alias for all users"
### https://askubuntu.com/questions/610052/how-can-i-preset-aliases-for-all-users
echo "alias k='kubectl'" >> /etc/profile.d/00-aliases.sh