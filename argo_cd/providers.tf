# A $KUBECONFIG env variable is expected: echo $KUBECONFIG 
# # <https://kubernetes.io/docs/concepts/configuration/organize-cluster-access-kubeconfig/#the-kubeconfig-environment-variable>

# Get local environment variables
data "external" "kube_path" {
  program = ["jq", "-n", "env"]
}

# Configure Kubernetes provider
provider "kubernetes" {
  config_path = data.external.kube_path.result.KUBECONFIG
}

provider "helm" {
  kubernetes {
    config_path = data.external.kube_path.result.KUBECONFIG
  }
}
