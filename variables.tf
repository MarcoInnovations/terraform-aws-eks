variable "region" {
  description = "AWS region"
}

variable "vpc_id" {
  description = "ID of VPC to deploy the cluster"
}

variable "private_subnets" {
  type        = "list"
  description = "All private subnets in your VPC"
}

variable "public_subnets" {
  type        = "list"
  default     = []
  description = "Public subnets in your VPC EKS can use"
}

variable "cluster_prefix" {
  description = "Name prefix of your EKS cluster"
}

variable "http_proxy" {
  description = "IP[:PORT] address and  port of HTTP proxy for your environment"
  default     = ""
}

variable "no_proxy" {
  description = "Endpoint that do not need to go through proxy"
  default     = ""
}

variable "key_name_ops" {
  description = "Key pair to use to access the instance created by the ASG/LC"
}

variable "key_name_app" {
  description = "Key pair to use to access the instance created by the ASG/LC"
}

variable "outputs_directory" {
  description = "The local folder path to store output files. Must end with '/' ."
  default     = "./output/"
}

variable "aws_authenticator_env_variables" {
  description = "A map of environment variables to use in the eks kubeconfig for aws authenticator"
  type        = "map"
  default     = {}
}

variable "tags" {
  description = "Map of tags to apply to deployed resources"
  type        = "map"
  default     = {}
}

variable "enable_cluster_autoscaling" {
  description = "Turn autoscaling on for your worker group"
  default     = false
}

variable "enable_pod_autoscaling" {
  description = "Enable horizontal pod autoscaling"
  default     = false
}

variable "cluster_version" {
  description = "Version of k8s to use (eks version is derived from here)"
  default     = "1.11"
}

variable "protect_cluster_from_scale_in" {
  description = "Protect nodes from scale in: # of nodes grow, will not shrink."
  default     = false
}

variable "install_helm" {
  description = "Install Helm during the deployment of the module"
  default     = true
}

variable "allowed_worker_ssh_cidrs" {
  type        = "list"
  description = "List of CIDR ranges to allow SSH access into worker nodes"
  default     = []
}

variable "worker_node_sysops_min" {
  default = 1
}

variable "worker_node_sysops_max" {
  default = 1
}

variable "worker_node_sysops_desired" {
  default = 1
}

variable "worker_node_sysops_instance" {
  default = "t3.medium"
}

variable "worker_node_app_min" {
  default = 1
}

variable "worker_node_app_max" {
  default = 1
}

variable "worker_node_app_desired" {
  default = 1
}

variable "worker_node_app_instance" {
  default = "t3.medium"
}

variable "worker_group_count" {}
