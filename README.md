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
