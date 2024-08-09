resource "helm_release" "app" {
  name      = "app"
  namespace = "default"
  chart     = "../helm/charts/hello-world"

  set {
    name  = "image.tag"
    value = "main"
  }

  lifecycle {
    prevent_destroy = true
  }
  
}
