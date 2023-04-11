
provider "aws"{
  profile = "personal"
}

locals{
  efs_file_system_id = aws_efs_file_system.app_efs.id
}

############################################################################
# QUERY SUBNET DATA
############################################################################
data "aws_subnets" "app_tier" {
  count = !var.provide_subnets ? 1 : 0

  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }

  tags   = var.subnet_query_tag

}


############################################################################
#CREATE SECURITY GROUP TO ATTACH TO EFS FILE SYSTEM
############################################################################
resource "aws_security_group" "efs_sec_group" {
  count = var.create_security_group ? 1 : 0
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

############################################################################
# CREATE EFS FILE SYSTEM
############################################################################

resource "aws_efs_file_system" "app_efs" {
  performance_mode = var.efs_perf_mode
  creation_token = var.creation_token
  encrypted = var.encrypt
  throughput_mode = var.throughput_mode
  kms_key_id =  var.kms_key_id


  lifecycle_policy {
    transition_to_ia = var.transition_to_ia
    #transition_to_primary_storage_class = var.transition_to_primary_storage_class

  }

  tags = var.efs_tags
}

############################################################################
# CREATE EFS FILE SYSTEM MOUNT TARGETS
############################################################################

resource "aws_efs_mount_target" "app_efs_mt" {
  count = var.provide_subnets ? length(var.subnets) : length(data.aws_subnets.app_tier[0].ids)

  file_system_id  = local.efs_file_system_id
  subnet_id       = var.provide_subnets ? var.subnets[count.index] : data.aws_subnets.app_tier[0].ids[count.index]
  security_groups = var.create_security_group ?  [aws_security_group.efs_sec_group[0].id] : var.efs_security_group_ids
}




############################################################################
# ATTACH EFS FILE SYSTEM POLICY
############################################################################

resource "aws_efs_file_system_policy" "app_efs_policy" {
  count = var.create_efs_policy ? 1 : 0

  file_system_id = local.efs_file_system_id

  policy = var.efs_policy

}

############################################################################
#CREATE EFS ACCESS POINT
############################################################################

resource "aws_efs_access_point" "app_access_point" {
  count = var.create_efs_access_point ? 1 : 0
  file_system_id = local.efs_file_system_id



  dynamic "posix_user"{
    for_each = var.posix_user

    content {
      gid = posix_user.value.gid
      uid = posix_user.value.uid
    }
  }

 dynamic "root_directory" {
    for_each = var.root_directories
    content {
      path            = root_directory.value.path

      dynamic "creation_info" {
        for_each = root_directory.value.creation_info
        content {
          owner_gid    = creation_info.value.owner_gid
          owner_uid    = creation_info.value.owner_uid
          permissions  = creation_info.value.permissions
        }
      }
    }
  }


  tags = var.efs_tags
}

############################################################################
# CREATE EFS BACKUP POLICY
############################################################################
resource "aws_efs_backup_policy" "app_backup_policy" {
  count = var.create_efs_backup_policy ? 1 : 0
  file_system_id = local.efs_file_system_id

  backup_policy {
    status = var.backup_policy_status
  }
}

############################################################################
# CREATE REPLICATION CONFIGURATION
############################################################################

resource "aws_efs_replication_configuration" "app_rep_config" {
  count = var.create_replication_configuration ? 1 : 0

  source_file_system_id = local.efs_file_system_id

  dynamic "destination" {
    for_each = var.replication_configuration_destination

    content {
      availability_zone_name = try(destination.value.availability_zone_name, null)
      kms_key_id             = try(destination.value.kms_key_id, null)
      region                 = try(destination.value.region, null)
    }
  }
}