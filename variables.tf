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

variable "efs_perf_mode" {
 description = "he performance mode of the EFS file system. Valid values are 'generalPurpose', 'maxIO', and 'throughputOptimized'."
 type= string
 default = "generalPurpose"
  
}

variable "efs_policy" {
  description = "The policy statement string to apply to the EFS file system"
  type        = string
  default     = null
}


variable "transition_to_ia" {
  description = "Period of time that a file is not accessed, after which it transitions to IA storage"
  type        = string
  default     = "AFTER_90_DAYS"
}



variable "efs_tags" {
  description = "Tags to assign to EFS File System"
  type        = map(string)
  default     = {}
}


variable "vpc_id" {
  description = "VPC ID for app tier"
  type        = string
}

variable "env_type" {
  description = "Deployment Environment type. Prod/Non-Prod"
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


variable "app_env" {
  description = "Deployment Environment"
  type        = string
}

variable "app_name" {
  description = "Application Name"
  type        = string
}
