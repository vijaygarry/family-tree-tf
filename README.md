# family-tree-tf
Deployment scripts to deploy family tree in AWS

source/
├── common                # Script common for all environment like dev or prod. This folder will have all the tf scripts
|   ├──  modules/
│   |    ├── vpc/
│   |    │   ├── main.tf       # Creates VPC, public subnet, IGW, route table, associations
│   |    │   ├── variables.tf  # Variables used inside the VPC module
│   |    │   └── outputs.tf    # Outputs VPC ID and public subnet ID
│   |    ├── security/
│   |    │   ├── main.tf       # Creates security group and network ACL allowing only HTTPS
│   |    │   ├── variables.tf  # Variables used inside security module
│   |    │   └── outputs.tf    # Outputs security group ID
│   |    └── ec2/
│   |        ├── main.tf       # Creates EC2 instance with user-data shell script
│   |        ├── variables.tf  # Variables used inside EC2 module
│   |        └── outputs.tf    # Outputs EC2 instance ID and public IP
|   ├── scripts/
|   |     ├── startup-uat.sh    # Startup shell script for UAT EC2 instance
|   |     └── startup-prod.sh   # Startup shell script for PROD EC2 instance
|   ├── main.tf               # Root file that calls modules to build VPC, Security, EC2
|   ├── variables.tf          # Defines all input variables for the root module
|   ├── outputs.tf            # Defines outputs (like EC2 public IP, VPC ID) from root module
|   ├── provider.tf           # Provider information
├── envs/
│   ├── dev.tfvars        # Variable values for DEV environment
|   |     ├── modules    # Symlink for common modules
|   |     └── scripts   # Symlink to common script folder
|   ├── main.tf               # Symlink to common main.tf
|   ├── variables.tf          # Symlink to common variables.tf
|   ├── outputs.tf            # Symlink to common outputs.tf
|   ├── provider.tf           # Symlink to common provider.tf
│   └── prod.tfvars       # Variable values for PROD environment
└──


Steps to run the script:

Create AWS account profile as :
vi ~/.aws/credentials
```
[dev]
aws_access_key_id = UAT_ACCESS_KEY
aws_secret_access_key = UAT_SECRET_KEY
region = us-east-1

[prod]
aws_access_key_id = PROD_ACCESS_KEY
aws_secret_access_key = PROD_SECRET_KEY
region = us-east-1
```

Terraform setup:
Install terraform (I am using Terraform v1.12.2)
Add terraform in path:
vi ~/.zshrc
```
export PATH=/Users/vijaygarothaya/work/installations/terraform_1.12.2:$PATH
alias tf='terraform'
```


Create following symlink if does not exists already
Step to create symlink:
cd source/env/dev
ln -s ../../common/modules modules
ln -s ../../common/scripts scripts

ln -s ../../common/main.tf main.tf
ln -s ../../common/output.tf output.tf
ln -s ../../common/provider.tf provider.tf
ln -s ../../common/variables.tf variables.tf
ln -s ../../common/output.tf output.tf


Initialize Terraform :
For DEV env, 
cd env/dev
// Init terraform
terraform init -var-file="dev.tfvars"
// Plan
tf plan -var-file="dev.tfvars"
// Apply the changes
terraform apply -var-file="dev.tfvars"

Deploy PROD:
cd env/prod
// Init terraform
terraform init -var-file="prod.tfvars"
// Plan
tf plan -var-file="prod.tfvars"
// Apply the changes
terraform apply -var-file="prod.tfvars"
