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

variable "worker_groups" {
  type = "list"

  default = [
    {
      name                  = "worker_group_sysops_"
      kubelet_extra_args    = "--node-labels=worker_group=sysops"
      asg_min_size          = "${var.worker_node_sysops_min}"
      asg_max_size          = "${var.worker_node_sysops_max}"
      asg_desired_capacity  = "${var.worker_node_sysops_desired}"
      instance_type         = "${var.worker_node_sysops_instance}"
      key_name              = "${var.key_name_ops}"                                   # The key name that should be used for the instances in the autoscaling group
      pre_userdata          = "${data.template_file.http_proxy_workergroup.rendered}" # userdata to pre-append to the default userdata.
      autoscaling_enabled   = "${var.enable_cluster_autoscaling}"
      protect_from_scale_in = "${var.protect_cluster_from_scale_in}"
      subnets               = "${join(",", var.private_subnets)}"                     # A comma delimited string of subnets to place the worker nodes in. i.e. subnet-123,subnet-456,subnet-789
    },
    {
      name                  = "worker_group_app_"
      kubelet_extra_args    = "--node-labels=worker_group=app"
      asg_min_size          = "${var.worker_node_app_min}"
      asg_max_size          = "${var.worker_node_app_max}"
      asg_desired_capacity  = "${var.worker_node_app_desired}"
      instance_type         = "${var.worker_node_app_instance}"
      key_name              = "${var.key_name_app}"                                   # The key name that should be used for the instances in the autoscaling group
      pre_userdata          = "${data.template_file.http_proxy_workergroup.rendered}" # userdata to pre-append to the default userdata.
      autoscaling_enabled   = "${var.enable_cluster_autoscaling}"
      protect_from_scale_in = "${var.protect_cluster_from_scale_in}"
      subnets               = "${join(",", var.private_subnets)}"                     # A comma delimited string of subnets to place the worker nodes in. i.e. subnet-123,subnet-456,subnet-789
    },
  ]
}
