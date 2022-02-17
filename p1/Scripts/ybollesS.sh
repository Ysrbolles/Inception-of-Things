curl -sfL https://get.k3s.io | sh -
echo "Sleeping for 5 seconds to wait for k3s to start"
sudo cp /var/lib/rancher/k3s/server/token /vagrant_shared 
sudo cp /etc/rancher/k3s/k3s.yaml /vagrant_shared