data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/${var.ubuntu}-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["099720109477"] # Canonical
}

resource "aws_key_pair" "key_pair" {
  key_name   = lower(var.base_name)
  public_key = var.ssh_pubkey
}

data "template_cloudinit_config" "config" {
  gzip          = true
  base64_encode = true
  part {
    content_type = "text/cloud-config"
    content = templatefile("${path.root}/setup_system.yaml", {
      base_name : var.base_name,
      app_directory : var.app_directory,
      app_repository_url : var.app_repository_url
    })
  }
}

resource "aws_launch_configuration" "instance" {
  name_prefix                 = "${var.base_name}-"
  image_id                    = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  associate_public_ip_address = true
  security_groups             = [aws_security_group.ssh_and_app.id]
  key_name                    = aws_key_pair.key_pair.key_name
  user_data_base64            = data.template_cloudinit_config.config.rendered
  lifecycle {
    create_before_destroy = true
  }
}
