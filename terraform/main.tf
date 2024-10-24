
provider "kubernetes" {
  host                   = azurerm_kubernetes_cluster.main.kube_config.0.host
  cluster_ca_certificate  = base64decode(azurerm_kubernetes_cluster.main.kube_config.0.cluster_ca_certificate)
  token                   = data.azurerm_kubernetes_cluster.main.kube_admin_config.0.token
}

resource "kubernetes_deployment" "bookmanager" {
  metadata {
    name = "bookmanager-api"
    labels = {
      app = "bookmanager-api"
    }
  }
  spec {
    replicas = 3
    selector {
      match_labels = {
        app = "bookmanager-api"
      }
    }
    template {
      metadata {
        labels = {
          app = "bookmanager-api"
        }
      }
      spec {
        container {
          image = "${{ secrets.REGISTRY_URL }}/bookmanager-api:latest"
          name  = "bookmanager-api"
          port {
            container_port = 8080
          }
        }
      }
    }
  }
}
