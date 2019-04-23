variable "region" {}

variable "vpc_id" {}

variable "private_subnets" {
  type = "list"
}

variable "public_subnets" {
  type    = "list"
  default = []
}

variable "aws_profile" {}

variable "cluster_prefix" {}

variable "http_proxy" {}

variable "no_proxy" {}

variable "key_name_ops" {}

variable "key_name_app" {}

variable "enable_cluster_autoscaling" {}

variable "enable_pod_autoscaling" {}

variable "cluster_version" {}

variable "protect_cluster_from_scale_in" {}

variable "worker_node_sysops_min" {}

variable "worker_node_sysops_max" {}

variable "worker_node_sysops_desired" {}

variable "worker_node_sysops_instance" {}

variable "worker_node_app_min" {}

variable "worker_node_app_max" {}

variable "worker_node_app_desired" {}

variable "worker_node_app_instance" {}

variable "aws_authenticator_env_variables" {
  description = "A map of environment variables to use in the eks kubeconfig for aws authenticator"
  type        = "map"
  default     = {}
}

variable "allowed_worker_ssh_cidrs" {
  type    = "list"
  default = []
}

variable "install_helm" {
  default = true
}

variable "worker_group_count" {
  default = "1"
}
