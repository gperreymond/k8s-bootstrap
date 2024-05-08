#!/bin/bash
set -e

INSTANCE_NAME=$(hostname)
INSTANCE_IP="${1}"
K3D_VERSION="5.6.3"
DOCKER_VERSION="5:26.1.1-1~ubuntu.20.04~focal"
KUBERNETES_VERSION="1.29.4"

sudo apt update
sudo apt install -y ca-certificates curl jq

# Add Docker's official GPG key
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update

# Instal docker
sudo apt install -y docker-ce=$DOCKER_VERSION docker-ce-cli=$DOCKER_VERSION containerd.io docker-buildx-plugin docker-compose-plugin
set +e
sudo groupadd docker
sudo usermod -aG docker $USER
sudo usermod -aG docker vagrant
set -e

# Install k3d
curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | TAG=v$K3D_VERSION bash

# Start kubernetes at edge
cat <<EOF > cluster.yaml
apiVersion: k3d.io/v1alpha5
kind: Simple
metadata:
  name: $INSTANCE_NAME
options:
  kubeconfig:
    updateDefaultKubeconfig: true
kubeAPI:
  hostIP: "${INSTANCE_IP}"
image: rancher/k3s:v${KUBERNETES_VERSION}-k3s1
servers: 1
agents: 1
ports:
  - port: '80:80'
    nodeFilters:
      - loadbalancer
  - port: '443:443'
    nodeFilters:
      - loadbalancer
EOF
is_empty=$(k3d cluster list -o json | jq 'length == 0')
if [ "$is_empty" = true ]; then
  k3d cluster create --config cluster.yaml
fi

echo ""
echo "------------------------------------------------------"
echo "[INFO] instance's name is $INSTANCE_NAME"
echo "[INFO] instance's ip is $INSTANCE_IP"
echo "[INFO] docker version is $INSTANCE_NAME"
echo "[INFO] k3d version is $DOCKER_VERSION"
echo "[INFO] k3d version is $KUBERNETES_VERSION"
echo "------------------------------------------------------"
echo ""