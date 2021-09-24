# Update Helm Provider KUBECONFIG path with local env KUBECONFIG path 
# A $KUBECONFIG env variable is expected: echo $KUBECONFIG 
# # <https://kubernetes.io/docs/concepts/configuration/organize-cluster-access-kubeconfig/#the-kubeconfig-environment-variable>

# Get local environment variables
data "external" "kube_path" {
  program = ["jq", "-n", "env"]
}


provider "helm" {
  kubernetes {
    config_path = data.external.kube_path.result.KUBECONFIG
  }
}

provider "kubernetes" {
  config_path = data.external.kube_path.result.KUBECONFIG
}

