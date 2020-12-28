terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "3.22.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

data "external" "provisioner_cidr" {
  program = ["sh", "get_provisioner_cidr.sh"]
}

variable "environment" {
  type = string
  default = "dev"
}

resource "aws_key_pair" "main" {
  key_name   = "opentransplant_cluster_key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDDSAuI5zDp6aGlFLloGdjObF29ecadkzWeVPyqEgJzdd715XHgIzklg0VZXbJnT3zmkfWsJWYlfUYc3dQPFVMRKI9+IeORzI6dMU2YxmNyC6dR3vld4tVbu6bcRwvyl+doF/kYWZDPsylMC74n1PbfUMvrQb1nDjoFMEphfTKeR4QI+sZAxahymtuw+NF6NLmM2+AXgKfgq6c1bePyvIswNpIXvn74v4zHiHhBM9Nk5GnF4EA+Vs2MJ86d3qUjrCoVgiwrC0jXFJRUK9pWfwFwB3HwD1HCJc+a7YakX6D6fMwjHfpxGddrdUM+aeVl9SLW8ksvPx0R7IAddx40lj/eVmzYbgwInB0h1gftXtPcgtXNBuTS4nCxWvz78oIeHwxFbOo2w5ZBs/fzDZu8rgjYZQrvUBWzmXUxVfK8vbM7D4xZ5eyQ+rUaHC3+y2cO0hOnVRVBySqVpcj7sIyJMM43bDmtRdG39oEzj6bNyLcSVouhvF5KMPhL+vUyOuFoxhRtEIT4Sbi2nKmlmgCdE1WDJeF9+JhIq/nRVeLBjrcj6/V5FnWLEPz+ozzdvzPRvVxg+/qx3xuAZAW4VIHBYwxsqGekMVFKILBpg3ciD8mT0TN03Lun1c9pOsjloUPKA2oS0JfUrddSAr6BTRENMaveYLAozoC/+KQejH3S/lIkWQ=="
}

variable "ec2_instance_no" {
  type = number
  default = 2
}

variable "ec2_instance_ami" {
  type = string
  default = "ami-054e49cb26c2fd312"
}

variable "ec2_instance_type" {
  type = string
  default = "t4g.small"
}

// supported AZs for t4g instances
resource "random_shuffle" "availability_zone" {
  input         = ["us-east-1a", "us-east-1b", "us-east-1c", "us-east-1d", "us-east-1f"]
  result_count  = 1
}

resource "aws_vpc" "main" {
  cidr_block  = "10.0.0.0/16"
  tags = {
    Owner = "OpenTransplant"
    Env   = var.environment
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Owner = "OpenTransplant"
    Env   = var.environment
  }
}

resource "aws_route" "main" {
  route_table_id            = aws_vpc.main.main_route_table_id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id                = aws_internet_gateway.main.id
}

resource "aws_subnet" "main" {
  vpc_id              = aws_vpc.main.id
  cidr_block          = "10.0.0.0/16"
  availability_zone   = random_shuffle.availability_zone.result[0]

  tags = {
    Owner = "OpenTransplant"
    Env   = var.environment
  }
}

resource "aws_security_group" "main" {
  name                    = "main"
  revoke_rules_on_delete  = true
  vpc_id                  = aws_vpc.main.id

  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = [aws_vpc.main.cidr_block, data.external.provisioner_cidr.result.provisioner_cidr]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  tags  = {
    Owner = "OpenTransplant"
    Env   = var.environment
  }
}

// https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/placement-groups.html
resource "aws_placement_group" "main" {
  name      = "main"
  strategy  = "spread"  // strictly places a small group of instances across distinct underlying hardware to reduce correlated failures
  tags  = {
    Owner = "OpenTransplant"
    Env   = var.environment
  }
}

resource "aws_instance" "ec2_instances" {
  ami                           = var.ec2_instance_ami
  instance_type                 = var.ec2_instance_type
  count                         = var.ec2_instance_no
  placement_group               = aws_placement_group.main.id
  disable_api_termination       = false
  subnet_id                     = aws_subnet.main.id
  vpc_security_group_ids        = [aws_security_group.main.id]
  associate_public_ip_address   = true
  key_name                      = aws_key_pair.main.key_name
  
  root_block_device {
    volume_size           = 8
    delete_on_termination = true
  }

  tags = {
    Owner = "OpenTransplant"
    Env   = var.environment
  }
}

output "ec2_instance_public_ip" {
  value = aws_instance.ec2_instances[0].public_ip
}