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

> Note: The helm chart(s) have been pulled locally, inside charts files, to simplify deployment.
