# Gitops workflow

GitOps is a way to do Kubernetes cluster management and application delivery using declarative manifests that can be treated as code.
This example code will deploy the [openfaas](https://github.com/openfaas/faas-netes/tree/master/chart/openfaas) helm chart using a set of different tools.

This is a good starting point when first discovering how helm charts/yaml manifests can be managed through a gitops workflow.

At a glance:

- terraform helm provider is used to deploy openfaas

- flux operator is used to deploy openfaas

- argocd operator is used to deploy openfaas

Follow the "How to" instructions for single command deployment using `make`

Access openfaas UI in: <http://localhost:8080/>

> Note: Flux is installed using terraform flux provider as there is no helm chart available yet.

## Prerequisites

- Docker desktop

- make

- jq

### Tools used in the workflow

- terraform helm provider
- argocd
- flux

### How to

> Important: A [$KUBECONFIG](https://kubernetes.io/docs/concepts/configuration/organize-cluster-access-kubeconfig/#the-kubeconfig-environment-variable) env variable is expected:

`echo $KUBECONFIG`

Verify prerequisites have been installed and Docker Desktop is running.

`git clone https://github.com/J0hn-B/gitops_workflow`

`cd ~/gitops_workflow`

For terraform helm provider:

- `make terraform` to deploy

- `make clean` to clean up

For fluxV2 operator:

- `make flux` to deploy

- `make clean` to clean up

For argocd operator:

- `make argocd` to deploy

- `make clean` to clean up

Follow the terminal for instructions on how to access openfaas ui
