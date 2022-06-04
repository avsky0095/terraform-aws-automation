belajar markdown

Terraform creation

[ Plan ]

- VPC Flow Logs
- IAM, Policy/Role
- RDS
- S3
- Logging + Trigger: CloudTrail -> S3 -> EventBridge - Lambda Function (tagging func)

[ Progress ]

Autoscaling:
- Load Balancer // bermasalah
- Listener
- Target Group
- Autoscaling with policy

[ Prioritas ]

- Autoscaling
- Cloudtrail - tagging
- Role for Budgets (ec2 stop after exceed budget limit)
- EC2 alpine nat instance

[ Success ]

EC2:
- Standard
- Spot Instance Request
- NAT Instance / Bastion Host

Autoscaling:
- Autoscaling Group
- Launch Template

Images:
- AMI+etc Filter Search

Firewall:
- Network ACL (+NACLAssociate)
- Security Groups

VPC:
- VPC
- Internet/NAT Gateway
- ElasticIP
- Network Interface
- Subnets
- Route Tables (+RTAssociate)

Providers:
Variables (+terraform.tfvars):
Output:
User data: