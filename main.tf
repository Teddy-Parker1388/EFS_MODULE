



data "aws_subnets" "app_tier" {

  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }

  tags   = { 
    Name = "*-${var.env_type}-app-tier*" 
    }

}


resource "aws_security_group" "efs_sec_group" {
  name        = var.efs_sec_grp_name
  description = var.efs_sec_grp_desc
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = var.efs_ingress
    content {
      from_port   = ingress.value.port
      to_port     = ingress.value.port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr
    }
  }

  dynamic "egress" {
    for_each = var.efs_egress
    content {
      from_port   = egress.value.port
      to_port     = egress.value.port
      protocol    = egress.value.protocol
      cidr_blocks = egress.value.cidr
    }
  }
}



resource "aws_efs_file_system" "app_efs" {
  performance_mode = var.efs_perf_mode
  creation_token = "${var.app_name}_${var.app_env}_services"
  encrypted = var.encrypt
  throughput_mode = var.throughput_mode


  lifecycle_policy {
    transition_to_ia = var.transition_to_ia

  }

  tags = var.efs_tags
}


resource "aws_efs_mount_target" "app_efs_mt" {
  count = length(data.aws_subnets.app_tier.ids)

  file_system_id  = aws_efs_file_system.app_efs.id
  subnet_id       = tolist(data.aws_subnets.app_tier.ids)["${count.index}"]
  security_groups = [aws_security_group.efs_sec_group.id]
}



resource "aws_efs_file_system_policy" "app_efs_policy" {
  count = var.create_efs_policy ? 1 : 0
  file_system_id = aws_efs_file_system.app_efs.id

  policy = var.efs_policy

}
