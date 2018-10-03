output "kubeconfig" {
  value = "${local.kubeconfig}"
}

output "config-map-aws-auth" {
  value = "${local.config-map-aws-auth}"
}

output "repository_url" {
  value = "${aws_ecr_repository.arc.repository_url}"
}
