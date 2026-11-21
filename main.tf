data "aws_security_group" "kind" {
  id = var.security_group_id
}

data "aws_subnets" "public" {
  count = var.subnet_id == null ? 1 : 0

  filter {
    name   = "vpc-id"
    values = [data.aws_security_group.kind.vpc_id]
  }

  filter {
    name   = "map-public-ip-on-launch"
    values = ["true"]
  }
}

locals {
  subnet_id = var.subnet_id != null ? var.subnet_id : data.aws_subnets.public[0].ids[0]
}

resource "aws_instance" "kind" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = local.subnet_id
  vpc_security_group_ids      = [var.security_group_id]
  associate_public_ip_address = true

  # Spot with no max_price: AWS caps the bid at the On-Demand price and charges the current Spot price.
  instance_market_options {
    market_type = "spot"
    spot_options {
      spot_instance_type             = "one-time"
      instance_interruption_behavior = "terminate"
    }
  }

  root_block_device {
    volume_size = var.root_volume_size_gb
    volume_type = "gp3"
    encrypted   = true
  }

  user_data = templatefile("${path.module}/scripts/user-data.sh.tftpl", {
    ssh_user     = var.ssh_user
    ssh_password = var.ssh_password
  })
  user_data_replace_on_change = true

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  lifecycle {
    precondition {
      condition     = var.subnet_id != null || length(try(data.aws_subnets.public[0].ids, [])) > 0
      error_message = "No subnet with map-public-ip-on-launch was found in the security group VPC. Set subnet_id to a public subnet in that VPC."
    }
  }

  timeouts {
    create = "20m"
    delete = "20m"
  }

  tags = {
    Name = "kind-cluster"
  }
}

resource "null_resource" "bootstrap" {
  triggers = {
    instance_id = aws_instance.kind.id
    script_sha  = filesha256("${path.module}/scripts/bootstrap.sh")
  }

  connection {
    type     = "ssh"
    host     = aws_instance.kind.public_ip
    user     = var.ssh_user
    password = var.ssh_password
    timeout  = "15m"
  }

  provisioner "file" {
    source      = "${path.module}/scripts/bootstrap.sh"
    destination = "/tmp/bootstrap.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "cloud-init status --wait || true",
      "chmod 0755 /tmp/bootstrap.sh",
      "KIND_CLUSTER_NAME='${var.kind_cluster_name}' /tmp/bootstrap.sh",
    ]
  }
}
