#!/usr/bin/env bash

# Parameters
#CLUSTER_NAME=${CLUSTER_NAME:-g-workflow} # Use g-workflow value if no var is set at execution time.

# Check if K3d is installed. If not, install K3d
if [ "$(command -v k3d)" ]; then
    echo "--> k3d exists, skip install"
else
    echo "> > > k3d does not exist, installing now"
    wget -q -O - https://raw.githubusercontent.com/rancher/k3d/main/install.sh | bash || exit 1
fi

# Prepare the k3d cluster
if [ "$(k3d cluster list "$CLUSTER_NAME")" ]; then
    echo -e "${GREEN}==> Cluster:${NC} $CLUSTER_NAME"
else
    echo -e "==>  Cluster does not exist"
    k3d cluster create "$CLUSTER_NAME" --agents 2
fi
