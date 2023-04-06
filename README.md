# Terrfaform Module to create EFS File System on AWS
----------------------------------------------------

## Resources Module Creates
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
|efs_perf_mode|The performance mode of the EFS file system. Valid values are 'generalPurpose', 'maxIO', and 'throughputOptimized'|string|generalPurpose|
|create_efs_policy|Specifies whether to create EFS Policy Statement|bool|false|
|encrypt|Specifies whether EFS File System should be encrypted.| bool|false|
