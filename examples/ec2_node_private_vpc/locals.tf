locals {
  aws_authenticator_env_variables = {
    #    AWS_PROFILE = "${var.aws_profile}"
  }

  tags = {
    Owner         = "Peter Parker"
    ProductDomain = "${var.cluster_prefix}"
    Environment   = "dev"
  }
}
