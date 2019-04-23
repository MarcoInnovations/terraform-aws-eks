locals {
  worker_group_defaults = {}

  worker_groups_merged = "${merge(local.worker_group_defaults, var.worker_groups)}"

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
