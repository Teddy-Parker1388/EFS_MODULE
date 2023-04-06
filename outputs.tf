output "efs_dns_name" {
  description = "The DNS name of the created EFS File System"
  value = aws_efs_file_system.app_efs.dns_name
}
