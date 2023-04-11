##################################################################
# EFS File System
##################################################################


variable "efs_perf_mode" {
 description = "The performance mode of the EFS file system. Valid values are 'generalPurpose', 'maxIO', and 'throughputOptimized'."
 type= string
 default = "generalPurpose"
  
}

variable "encrypt" {
  description = "Specifies whether EFS File System shoudl be encrypted"
  type = bool
  default = false
  
}

variable "throughput_mode" {
  type        = string
  description = "The throughput mode of the EFS file system. Valid values are 'bursting' and 'provisioned'."
  default     = "bursting"
}

variable "transition_to_ia" {
  description = "Period of time that a file is not accessed, after which it transitions to IA storage"
  type        = string
  default     = "AFTER_90_DAYS"
}

variable "kms_key_id"{
  description = "The ARN for the KMS encryption key. When specifying kms_key_id, encrypted needs to be set to true."
  type = string
  default = null
}

variable "transition_to_primary_storage_class" {
  description = "Describes the policy used to transition a file from infequent access storage to primary storage."
  type = string
  default = "AFTER_1_ACCESS"
}

variable "creation_token" {
  description = "A unique name (a maximum of 64 characters are allowed) used as reference when creating the Elastic File System"
  type = string
  default = null
}

##################################################################
# Security Group
##################################################################

variable "create_security_group" {
  description = "Specifies whether to create security group in child module (true) or in root module(false)"
  type = bool
  default = true
}

variable "vpc_id" {
  description = "VPC ID for app tier"
  type        = string
}


variable "efs_sec_grp_name" {
  description = "Name of EFS Security Group"
  type = string
  default = null
}

variable "efs_sec_grp_desc" {
  description = "Description of EFS Security Group"
  type = string
  default = null
}

variable "efs_ingress" {
  description = "EFS Ingress Rules"
  type = list(object({
    port = number
    protocol = string
    cidr = list(string)
  }))
  default = []

}

variable "efs_egress" {
  description = "EFS Egress Rules"
  type = list(object({
    port = number
    protocol = string
    cidr = list(string)
  }))
  default = []

}

##################################################################
# Mount Target
##################################################################

variable "provide_subnets" {
  description = "Specifies whether to use data block in module to query subnet information (true) or provide subnet information in root module (false)"
  type = bool
  default = false
}

variable "efs_security_group_ids" {
  description = "The IDs of the security group(s). Required if provide_security_group= true"
  type        = list(string)
  default = []
}

variable "subnets" {
  description = "The IDs of the subnets. Required if provide_subnets = true"
  type        = list(string)
  default = []
}

##################################################################
# File System Policy
##################################################################

variable "efs_policy" {
  description = "The policy statement string to apply to the EFS file system"
  type        = string
  default     = null
}

variable "create_efs_policy" {
  description = "Create EFS policy Statement ?"
  type = bool
  default = false
  
  
}

##################################################################
# Access Point
##################################################################

variable "root_directories" {
  description = "A map of root directories for each EFS access point. Each key is an access point ID and the value is an object with the path to the directory and the creation info, which includes the owner GID and UID, and permissions for that directory."
  type = map(object({
    path           = string
    creation_info = map(object({
      owner_gid    = number
      owner_uid    = number
      permissions  = string
    }))
  }))

  default = {}
  
}

variable "posix_user" {
  description = "A list  of POSIX user IDs objects for each EFS access point. "

  type = list(object({
    gid = number
    uid = number
  }))
  default = []
}

variable "create_efs_access_point" {
  description = "Specifies whether to create efs access point"
  type = bool
  default = false
}

##################################################################
# Backup Policy
##################################################################

variable "create_efs_backup_policy" {
  description = "Specifies whether to create efs access backup policy"
  type = bool
  default = false
}

variable "backup_policy_status" {
  description = "A status of the backup policy. Valid values: ENABLED, DISABLED"
  type = string
  default = "ENABLED"
}




##################################################################
# Replication Configuration
##################################################################
variable "create_replication_configuration" {
  description = "Determines whether a replication configuration is created"
  type        = bool
  default     = false
}

variable "replication_configuration_destination" {
  description = "A destination configuration block"
  type        = map(string)
  default     = {}
}

##################################################################
# Subnets Data etc
##################################################################

variable "efs_tags" {
  description = "Tags to assign to EFS File System"
  type        = map(string)
  default     = {}
}

variable "subnet_query_tag"{
  description = "Tags to use in aws_subnets data block"
  type = map(string)
  default = {}
}