output "vpc_id" {
  value = module.vpc.vpc_id
}

output "private_key" {
  value     = module.ec2.private_key
  sensitive = true
}

output helm_release {
  value = module.helm.helm_release
}

output "portforward_application" {
  value = "KUBECONFIG=k3s.yaml kubectl port-forward svc/app-hello-world --address 0.0.0.0 8080:8080 &"
}