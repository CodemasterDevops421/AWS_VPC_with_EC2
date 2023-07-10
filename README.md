# AWS VPC and EC2 Instance Creation with Terraform

This repository contains Terraform scripts for creating a VPC and an EC2 instance in AWS.

## Prerequisites

- AWS account
- AWS CLI installed and configured with your AWS account
- Terraform installed

## Usage

1. Clone this repository:

  ```
   git clone https://github.com/Chaitanyadevops421/AWS_VPC_with_EC2.git
  ```

Navigate to the repository directory:
cd AWS_VPC_with_EC2

Initialize Terraform:

```
terraform init
```

Plan the Terraform apply:

```
terraform plan
```

Apply the Terraform configuration:

```
terraform apply
```


Confirm the apply when prompted.


Resources Created:
VPC with CIDR block
Internet Gateway attached to the VPC
Route table associated with the VPC
Subnet within the VPC
EC2 instance within the subnet
Cleaning Up


To destroy the resources created by this configuration, run:
```
terraform destroy
```

Confirm the destroy when prompted.

License
This project is licensed under the MIT License - see the LICENSE file for details.


Please replace the placeholders with the actual details of your project. Also, make sure to include a `LICENSE` file in your repository if you mention it in the README.






