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
|env_type|Deployment Environment type. Prod/Non-Prod|string| | yes|
|efs_sec_grp_name|Name of EFS Security Group|string|null|no|
|efs_sec_grp_desc|Description of EFS Security Group|string|null|no|
|app_env|Deployment environment|string| |yes|
|app_name|Application name|string| |yes|

-----------------------------------------------------
## Outputs Supported
| Name | Description |
|------|-------------|
|efs_dns_name|The DNS name of the created EFS File System|



# EXAMPLE

### main.tf
```
module "efs_support" {



    source = "git@github.com:Teddy-Parker1388/EFS_MODULE.git"

    efs_ingress = local.ingress
    transition_to_ia = "AFTER_60_DAYS"
    efs_tags = local.common_tags
    vpc_id = "vpc-0a26fda417df79b23"
    env_type = var.app_env == "prod" ? "prod" : "non-prod"
    efs_sec_grp_name = "Example Security Group Name"
    efs_sec_grp_desc = "Example Security Group Description"
    app_env = var.app_env
    app_name = var.app_name
    encrypt = true
    create_efs_policy = true
    efs_policy = local.policy


}

```



