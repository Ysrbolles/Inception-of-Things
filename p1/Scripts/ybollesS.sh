export INSTALL_K3S_EXEC="--bind-address=192.168.42.110 --node-external-ip=192.168.42.110 --flannel-iface=eth1"
curl -sfL https://get.k3s.io | sh -
echo "Sleeping for 5 seconds to wait for k3s to start"
sleep 5
cp /var/lib/rancher/k3s/server/token /vagrant_shared 
cp /etc/rancher/k3s/k3s.yaml /vagrant_shared