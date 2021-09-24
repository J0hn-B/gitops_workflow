

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

# Create release
resource "helm_release" "openfaas_v8_0_4" {
  name      = "openfaas-8.0.4"
  chart     = "../helm_charts/openfaas-8.0.4.tgz"
  namespace = "openfaas"
  timeout   = 600

  set {
    name  = "functionNamespace"
    value = "openfaas-fn"
  }

  set {
    name  = "generateBasicAuth"
    value = "true"
  }
}

data "kubernetes_secret" "openfaas" {
  metadata {
    name      = "basic-auth"
    namespace = "openfaas"
  }
  depends_on = [helm_release.openfaas_v8_0_4]
}

output "openfaas-username" {
  value = "admin"
}

output "openfaas-password" {
  value = nonsensitive(data.kubernetes_secret.openfaas.data.basic-auth-password)
}
