export INSTALL_K3S_EXEC="--write-kubeconfig-mode=644 --bind-address=192.168.42.110 --node-ip=192.168.42.110 --tls-san $(hostname) --advertise-address=192.168.42.110"
echo "Installing k3s"
curl -sfL https://get.k3s.io | sh -
echo "Finished installing k3s"

echo "Deploying app1"
/usr/local/bin/kubectl apply -f /vagrant_shared/app1/
