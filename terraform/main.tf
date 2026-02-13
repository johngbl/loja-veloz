// Minimal Terraform skeleton for infra (edit provider and resources as needed)
terraform {
  required_version = ">= 1.0"
}

// Example: Kubernetes provider block (replace with your provider configuration)
# provider "kubernetes" {
#   config_path = var.kubeconfig_path
# }

resource "kubernetes_namespace" "loja_veloz" {
  metadata {
    name = "loja-veloz"
  }
}

output "namespace" {
  value = kubernetes_namespace.loja_veloz.metadata[0].name
}
