# Gitops workflow

This example code will deploy the openfaas helm chart using a set of different tools.

This is a good starting point when first discovering how resources can be managed through a gitops workflow.

## Prerequisites

- Docker desktop

- make

- jq

### Tools used in the workflow

- terraform helm provider
- argocd
- flux

> Note: The helm chart(s) have been pulled locally, inside helm_charts folder, to simplify deployment showcase.

### How to

> Important: A $KUBECONFIG env variable is expected: `echo $KUBECONFIG`

- > <https://kubernetes.io/docs/concepts/configuration/organize-cluster-access-kubeconfig/#the-kubeconfig-environment-variable>

Verify prerequisites have been installed and Docker Desktop is running.

`git clone https://github.com/J0hn-B/gitops_workflow`

`cd ~/gitops_workflow`

Follow the terminal for instructions on how to access openfaas ui

For terraform provider:

- `make terraform` to deploy

- `make clean` to clean up
