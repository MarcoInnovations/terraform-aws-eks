locals {
  worker_groups = [
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

  # worker_groups_merged = "${merge(local.worker_group_defaults, var.worker_groups)}"

  horizontal_pod_autoscaler_defaults = {}
  cluster_autoscaler_defaults = {
    namespace               = "kube-system"
    scale-down-enabled      = "${var.protect_cluster_from_scale_in}"
    scale-down-uneeded-time = 10
    scan-interval           = 10
  }
  enable_helm                = "${var.enable_cluster_autoscaling || var.enable_pod_autoscaling || var.install_helm ? 1 : 0}"
  enable_cluster_autoscaling = "${var.enable_cluster_autoscaling}"
  master_config_services_proxy = [
    {
      name = "kube-proxy"
      type = "daemonset"
    },
    {
      name = "coredns"    # In Kubernetes v1.10: dns is called 'kube-dns'; in v1.11+, dns is called 'coredns', but still has the app tag 'kube-dns'
      type = "deployment"
    },
    {
      name = "aws-node"
      type = "daemonset"
    },
  ]
  no_proxy_default = "localhost,127.0.0.1,169.254.169.254,10.0.0.0/8,172.16.0.0/12,192.168.0.0/16,.local,.internal,.elb.amazonaws.com,.elb.${var.region}.amazonaws.com"
  no_proxy_merged  = "${join(",", distinct(concat(split(",", local.no_proxy_default), split(",", var.no_proxy))))}"
}
