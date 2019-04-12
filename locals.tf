locals {
  # worker_group = [  #   {  #     name                  = "node"                                                  # Name of the worker group. Literal count.index will never be used but if name is not set, the count.index interpolation will be used.  #     asg_desired_capacity  = "${var.desired_worker_nodes}"                           # Desired worker capacity in the autoscaling group.  #     asg_max_size          = "${var.max_worker_nodes}"                               # Maximum worker capacity in the autoscaling group.  #     asg_min_size          = "${var.min_worker_nodes}"                               # Minimum worker capacity in the autoscaling group.  #     instance_type         = "${var.worker_node_instance_type}"                      # Size of the workers instances.  #     key_name              = "${var.key_name}"                                       # The key name that should be used for the instances in the autoscaling group  #     pre_userdata          = "${data.template_file.http_proxy_workergroup.rendered}" # userdata to pre-append to the default userdata.  #     additional_userdata   = ""                                                      # userdata to append to the default userdata.  #     subnets               = "${join(",", var.private_subnets)}"                     # A comma delimited string of subnets to place the worker nodes in. i.e. subnet-123,subnet-456,subnet-789  #     autoscaling_enabled   = "${var.enable_cluster_autoscaling}"  #     protect_from_scale_in = "${var.protect_cluster_from_scale_in}"  #   },  # ]

  # the commented out worker group list below shows an example of how to define
  # multiple worker groups of differing configurations
  worker_group = [
    {
      asg_desired_capacity = 1
      asg_max_size         = 6
      asg_min_size         = 1
      instance_type        = "${var.worker_node_instance_type_a}"
      name                 = "worker_group_a"
      additional_userdata  = "echo foo bar"
      subnets              = "${join(",", var.private_subnets)}"
    },
    {
      asg_desired_capacity = 1
      asg_max_size         = 10
      asg_min_size         = 2
      instance_type        = "${var.worker_node_instance_type_b}"
      name                 = "worker_group_b"
      additional_userdata  = "echo foo bar"
      subnets              = "${join(",", var.private_subnets)}"
    },
  ]

  # the commented out worker group tags below shows an example of how to define
  # custom tags for the worker groups ASG
  worker_group_tags = {
    worker_group_a = [
      {
        key                 = "k8s.io/cluster-autoscaler/node-template/taint/nvidia.com/gpu"
        value               = "gpu:NoSchedule"
        propagate_at_launch = true
      },
      {
        key                 = "Name"
        value               = "workergroup A"
        propagate_at_launch = true
      },
    ]

    worker_group_b = [
      {
        key                 = "k8s.io/cluster-autoscaler/node-template/taint/nvidia.com/gpu"
        value               = "gpu:NoSchedule"
        propagate_at_launch = true
      },
      {
        key                 = "Name"
        value               = "workergroup B"
        propagate_at_launch = true
      },
    ]
  }

  horizontal_pod_autoscaler_defaults = {}

  cluster_autoscaler_defaults = {
    namespace               = "kube-system"
    scale-down-enabled      = "${var.protect_cluster_from_scale_in}"
    scale-down-uneeded-time = 10
    scan-interval           = 10
  }

  enable_helm = "${var.enable_cluster_autoscaling || var.enable_pod_autoscaling || var.install_helm ? 1 : 0}"

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

  no_proxy_merged = "${join(",", distinct(concat(split(",", local.no_proxy_default), split(",", var.no_proxy))))}"
}
