# Terrfaform Module to create EFS File System on AWS
----------------------------------------------------

## Resources Supported
* ESF FIle System
* EFS Mount Target
* EFS Security Group
* EFS File System Policy
-----------------------------------------------------
## Inputs Supported
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
|efs_ingress| EFS Ingress Rules|list(object({port = number,protocol = string,cidr = list(string)})) |[] | no |
|efs_egress| EFS Egress Rules|list(object({port = number,protocol = string,cidr = list(string)})) |[] | no |
|efs_perf_mode|The performance mode of the EFS file system. Valid values are 'generalPurpose', 'maxIO', and 'throughputOptimized'|string|generalPurpose|no|
|create_efs_policy|Specifies whether to create EFS Policy Statement|bool|false|no|
|encrypt|Specifies whether EFS File System should be encrypted.| bool|false|no|
|throughput_mode|The throughput mode of the EFS file system. Valid values are 'bursting' and 'provisioned'.|string|bursting|no|
|efs_policy|The policy statement string to apply to the EFS file system |string | null | no |
|transition_to_ia|Period of time that a file is not accessed, after which it transitions to IA storage|string|AFTER_90_DAYS|no|
|efs_tags|Tags to assign to EFS File System|map(string)|{}|no|
|vp|c_id|VPC ID for app tier|string| |yes|
|efs_sec_grp_name|Name of EFS Security Group|string|null|no|
|efs_sec_grp_desc|Description of EFS Security Group|string|null|no|
|create_replication_configuration|Determines whether a replication configuration is created|bool|false|no|
|replication_configuration_destination|A destination configuration block|map(string)|{}|no|
|subnet_query_tag|Tags to use in aws_subnets data block|map(string)|{}|no|
|create_efs_backup_policy|Specifies whether to create efs access backup polcy|bool|false|no|
|backup_policy_status|A status of the backup policy. Valid values: ENABLED, DISABLED|string|ENABLED|no|
|create_efs_access_point|Specifies whether to create efs access point|bool|false|no|
|posix_user|A list  of POSIX user IDs objects for each EFS access point.|type = list(object({gid = number, uid = number}))|[]|no|
|root_directories|A map of root directories for each EFS access point. Each key is an access point ID and the value is an object with the path to the directory and the creation info, which includes the owner GID and UID, and permissions for that directory.|type = map(object({path           = string ,creation_info = map(object({owner_gid    = number ,owner_uid    = number ,permissions  = string}))}))|{}|no|
|subnets|The IDs of the subnets. Required if provide_subnets = true|list(string)|[]|no|
|provide_subnets|Specifies whether to use data block in module to query subnet information (true) or provide subnet information in root module (false)|bool|false|no|
|create_security_group|Specifies whether to create security group in child module (true) or in root module(false)|bool|false|no|

-----------------------------------------------------
## Outputs Supported
| Name | Description |
|------|-------------|
|efs_dns_name|The DNS name of the created EFS File System|
|efs_mount_target_ids|The IDs of the mount targets for the EFS file system|
|efs_backup_policy_id|The ID of the backup policy for the EFS file system|
|efs_access_point_arn|The ARN of the access point for the EFS file system|
|replication_configuration_destination_file_system_id|The file system ID of the replica|
|replication_configuration_destination_status|The status of the replication|
|security_group_id|ID of the security group|





# EXAMPLE

### main.tf
```
locals {
    ingress = [{
        port = 2049
        protocol = "tcp"
        cidr = ["0.0.0.0/0"]

    }]

    common_tags = {
        Name        = var.app_name
        Product     = var.app_product
        App         = var.app_name
        Environment = var.app_env
    }

    policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "AWS": "*"
            },
            "Action": [
                "elasticfilesystem:ClientWrite",
                "elasticfilesystem:ClientMount",
                "elasticfilesystem:ClientRootAccess"
            ],
            "Resource": "*",
            "Condition": {
                "Bool": {
                    "elasticfilesystem:AccessedViaMountTarget": "true"
                }
            }
        }
    ]
}
  POLICY
   
}

module "efs_support" {

    source = var.source

   
    transition_to_ia = "AFTER_60_DAYS"
    efs_tags = local.common_tags
    vpc_id = var.vpc_id
    encrypt = true

    #create security group using child module
    create_security_group = true
    efs_sec_grp_name = "Example Security Group Name"
    efs_sec_grp_desc = "Example Security Group Description"
    efs_ingress = local.ingress

    #efs policy
    create_efs_policy = true
    efs_policy = local.policy
     
    #efs backup policy
    create_efs_backup_policy  = true

    #use aws_subnet data block in child module to get subnet ids
    provide_subnets = false
    subnet_query_tag = { Name =  "*-prod-app-tier*"}
    


}
```
# EXAMPLE

### outputs.tf
```
output "efs_dns_name"{
    value = module.efs_support.efs_dns_name
}
```
