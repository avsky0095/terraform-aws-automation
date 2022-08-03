belajar markdown

Terraform creation

[ Plan ]
- DNS 
- CA CERTIFICATION (https: 443)
- ElasticCache
- VPC Flow Logs
- S3
- Logging + Trigger: CloudTrail -> S3 -> EventBridge - Lambda Function (tagging func)
- AWS SYSTEMMANAGER
- nomad, kubernetes

[ Progress ]


[ Prioritas ]

- Cloudtrail - tagging
- Role for Budgets (ec2 stop after exceed budget limit)
- IAM, Policy/Role, add iam role to instance (contoh ec2 -> untuk akses s3)

[ Success ]

EC2:
- Standard
- Spot Instance Request
- NAT Instance / Bastion Host (Amazon Linux 2)

RDS:
- MariaDB (standard)

Autoscaling:    (sementara)
- Load Balancer
- Listener
- Target Group
- Autoscaling with policy

Images:
- AMI+etc Filter Search

Firewall:
- Network ACL (+NACLAssociate)
- Security Groups

VPC:
- VPC
- Subnets
- Internet/NAT Gateway
- ElasticIP
- Network Interface
- Route Tables (+RTAssociate)

Providers:

Variables (+terraform.tfvars):

Output:

User data: