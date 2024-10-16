terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

  required_version = ">= 0.13.4"
}

provider "localstack" {
  endpoint = "http://localhost:4566"
}

resource "localstack_elb" "example" {
  name = "load-balancer-forapplication"
  listeners {
    protocol = "HTTP"
    port = 80
  }
  health_check {
    protocol = "HTTP"
    port = 80
    interval = 30
    healthy_threshold = 3
    unhealthy_threshold = 3
    timeout = 5
    path = "/"
  }
  instances {
    instance_id = "i-a2c30c584eae9ebe7"
  }
}
