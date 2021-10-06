
# Generate flux install manifests
data "flux_install" "main" {
  target_path    = "clusters/my-cluster"
  network_policy = false
}

resource "kubernetes_namespace" "flux_system" {
  metadata {
    name = "flux-system"
  }

  lifecycle {
    ignore_changes = [
      metadata[0].labels,
    ]
  }
}



# Split multi-doc YAML with kubectl community provider
# https://registry.terraform.io/providers/gavinbunney/kubectl/latest
data "kubectl_file_documents" "apply" {
  content = data.flux_install.main.content
}

# Convert documents list to include parsed yaml data
locals {
  apply = [for v in data.kubectl_file_documents.apply.documents : {
    data : yamldecode(v)
    content : v
    }
  ]
}


# Apply flux installation manifests on the cluster
resource "kubectl_manifest" "apply" {
  for_each   = { for v in local.apply : lower(join("/", compact([v.data.apiVersion, v.data.kind, lookup(v.data.metadata, "namespace", ""), v.data.metadata.name]))) => v.content }
  depends_on = [kubernetes_namespace.flux_system]
  yaml_body  = each.value
}

# Create helm release with fluxv2
data "kubectl_path_documents" "app_manifests" {
  pattern = "./clusters/dev/*.yaml"
}

resource "kubectl_manifest" "app_manifests_apply" {
  count      = length(data.kubectl_path_documents.app_manifests.documents)
  yaml_body  = element(data.kubectl_path_documents.app_manifests.documents, count.index)
  depends_on = [kubectl_manifest.apply]
}

# Wait for openfaas gateway to become available
resource "time_sleep" "wait_openfaas_gateway" {
  create_duration = "180s"
  depends_on      = [kubectl_manifest.app_manifests_apply]
}

# Return openfaas secret
data "kubernetes_secret" "openfaas" {
  metadata {
    name      = "basic-auth"
    namespace = "openfaas"
  }
  depends_on = [time_sleep.wait_openfaas_gateway]
}

# Credentials to access openfaas UI
output "openfaas-username" {
  value = "admin"
}

output "openfaas-password" {
  value = nonsensitive(data.kubernetes_secret.openfaas.data.basic-auth-password)
}
