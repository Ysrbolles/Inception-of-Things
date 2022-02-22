export K3S_KUBECONFIG_MODE="644"
export INSTALL_K3S_EXEC="--flannel-iface eth1"
curl -sfL https://get.k3s.io | sh -
echo "Finished installing k3s"

echo "Deploying app1"
/usr/local/bin/kubectl apply -f /vagrant_shared/app1/deployment.yaml
/usr/local/bin/kubectl apply -f /vagrant_shared/app2/deployment.yaml
/usr/local/bin/kubectl apply -f /vagrant_shared/app3/deployment.yaml
/usr/local/bin/kubectl apply -f /vagrant_shared/ingress.yaml
# /usr/local/bin/kubectl apply -f /vagrant_shared/app3/
echo "Finished deploying app1"

