#!/bin/bash

# Set Colors ##############################################################################
black=$(tput setaf 0)
red=$(tput setaf 1)
green=$(tput setaf 2)
yellow=$(tput setaf 3)
blue=$(tput setaf 4)

# Setup Tools ##############################################################################
echo "$blue Install net-tools $(tput sgr0)"
sudo apt install net-tools -y

# Add Alias ##############################################################################
echo "$blue Add k alias to all users $(tput sgr0)"
echo "alias k='kubectl'" >> /etc/profile.d/00-aliases.sh
source /etc/profile.d/00-aliases.sh

# Install Docker 
echo "$blue Install Docker $(tput sgr0)"
### https://docs.docker.com/engine/install/ubuntu/
  # Uninstall old versions if existe
sudo apt-get remove docker docker-engine docker.io containerd runc

  # Update apt package and install packages to allow apt use repository over HTTPS:
sudo apt-get update -y
sudo apt-get install ca-certificates curl gnupg lsb-release
  
  # Add Docker’s official GPG key:
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
  
  # Use the following command to set up the stable repository
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

  # Install Docker Engine
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io -y

# Install K3D on your VM
echo "$blue Install K3D $(tput sgr0)"
sudo wget -q -O - https://raw.githubusercontent.com/rancher/k3d/main/install.sh | bash

# Install Kubectl binary with curl on Linux
echo "$blue Install Kubectl $(tput sgr0)"
### https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/

  # Download latest release
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
  # Install kubectl
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

# Create K3d cluster without traefik and setup Argo CD ##############################################################################
### https://k3d.io/v5.3.0/usage/exposing_services/
### https://argo-cd.readthedocs.io/en/stable/getting_started/

echo "$blue Create K3d cluster $(tput sgr0)"
k3d cluster create mycluster -p 8080:80@loadbalancer -p 8888:30080@loadbalancer --agents 2 --k3s-arg "--disable=traefik@server:0"

echo "$blue Create argocd and dev namespaces $(tput sgr0)"
kubectl create namespace argocd
kubectl create namespace dev

echo "$blue Setup Argo CD $(tput sgr0)"
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

echo "$blue Waiting Argo CD Setup $(tput sgr0)"
params="-n argocd -l app.kubernetes.io/name=argocd-server --timeout=10m"
kubectl wait --for=condition=available deployment $params
kubectl wait --for=condition=ready pod $params

echo "$blue Config Access to Argo CD Server $(tput sgr0)"
kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'

echo "$blue Waiting Argo CD Config $(tput sgr0)"
params="-n argocd -l app.kubernetes.io/name=argocd-server --timeout=10m"
kubectl wait --for=condition=available deployment $params
kubectl wait --for=condition=ready pod $params

echo "Argo CD username: $green admin $(tput sgr0)"
echo "Argo CD Password: $red $(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d;) $(tput sgr0)"

echo "$blue Clone Argo CD manifest conf $(tput sgr0)"
sudo git clone https://github.com/issamelferkh/ybolles_config.git ~/p3
sudo kubectl apply -f ~/p3/argocd_manifest/manifest.yaml -n argocd
