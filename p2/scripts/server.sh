#!/bin/bash
echo "Install net-tools (ifconfig cmd)"
sudo yum install net-tools -y

echo "Install KS3 on controller mode"
### https://tferdinand.net/creer-un-cluster-kubernetes-local-avec-vagrant/
curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="--write-kubeconfig-mode=644 --bind-address=192.168.42.110 --node-ip=192.168.42.110 --tls-san $(hostname) --advertise-address=192.168.42.110" sh -

echo "Add k alias for all users"
### https://askubuntu.com/questions/610052/how-can-i-preset-aliases-for-all-users
echo "alias k='kubectl'" >> /etc/profile.d/00-aliases.sh

echo "Setup Web App 1"
/usr/local/bin/kubectl apply -f /vagrant/confs/app1.yaml -n kube-system

echo "Setup Web App 2"
/usr/local/bin/kubectl apply -f /vagrant/confs/app2.yaml -n kube-system

echo "Setup Web App 3"
/usr/local/bin/kubectl apply -f /vagrant/confs/app3.yaml -n kube-system

echo "Create Ingress"
/usr/local/bin/kubectl apply -f /vagrant/confs/ingress.yaml -n kube-system
