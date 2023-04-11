output "efs_dns_name" {
  description = "The DNS name of the created EFS File System"
  value = aws_efs_file_system.app_efs.dns_name
}

output "efs_mount_target_ids" {
  description = "The IDs of the mount targets for the EFS file system"
  value       = try(aws_efs_mount_target.app_efs_mt.*.id,null)
}

output "efs_backup_policy_id"{
  description = "The ID of the backup policy for the EFS file system"
  value       = try(aws_efs_backup_policy.app_backup_policy[0].id,null)

}

output "efs_access_point_arn" {
  description = "The ARN of the access point for the EFS file system"
  value = try(aws_efs_access_point.app_access_point[0].arn,null)
  
}

output "replication_configuration_destination_file_system_id" {
  description = "The file system ID of the replica"
  value       = try(aws_efs_replication_configuration.app_rep_config[0].destination[0].file_system_id, null)
}

output "replication_configuration_destination_status" {
  description = "The status of the replication"
  value       = try(aws_efs_replication_configuration.app_rep_config[0].destination[0].status, null)
}
output "security_group_id" {
  description = "ID of the security group created by module"
  value       = try(aws_security_group.efs_sec_group[0].id, null)
}
