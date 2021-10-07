# Create namespace
resource "kubernetes_namespace" "openfaas" {
  metadata {
    name = "openfaas"
  }
}

# Create namespace
resource "kubernetes_namespace" "openfaas-fn" {
  metadata {
    name = "openfaas-fn"
  }
}

# Install ArgoCD
resource "helm_release" "argocd_install" {
  name             = "argocd"
  chart            = "argo-cd"
  repository       = "https://argoproj.github.io/argo-helm"
  create_namespace = true
  namespace        = "argocd"
  timeout          = 999
  cleanup_on_fail  = true

}


# Create helm release with fluxv2
data "kubectl_path_documents" "app_manifests" {
  pattern = "./clusters/dev/*.yaml"
}

resource "kubectl_manifest" "app_manifests_apply" {
  count      = length(data.kubectl_path_documents.app_manifests.documents)
  yaml_body  = element(data.kubectl_path_documents.app_manifests.documents, count.index)
  depends_on = [helm_release.argocd_install]
}

# Return openfaas secret
data "kubernetes_secret" "openfaas" {
  metadata {
    name      = "basic-auth"
    namespace = "openfaas"
  }
  depends_on = [kubectl_manifest.app_manifests_apply]
}

# Credentials to access openfaas UI
output "openfaas-username" {
  value = "admin"
}

output "openfaas-password" {
  value = nonsensitive(data.kubernetes_secret.openfaas.data.basic-auth-password)
}
