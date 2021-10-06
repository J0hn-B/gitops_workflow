
# Install ArgoCD
resource "helm_release" "argocd_install" {
  name             = "argocd"
  chart            = "argo-cd"
  repository       = "https://argoproj.github.io/argo-helm"
  create_namespace = true
  namespace        = "argocd"
  timeout          = 900
  cleanup_on_fail  = true
}


