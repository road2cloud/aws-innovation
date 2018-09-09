#!/bin/bash

export PATH=$PATH:/Users/dimeh/Documents/workspace/SG/aws-innovation/terraform
export PATH=$PATH:/Users/dimeh/Documents/workspace/SG/aws-innovation/packer
HOME_PATH="/Users/dimeh/Documents/workspace/SG/aws-innovation"

##################################
# Initialize a VPC network ######
################################
cd $HOME_PATH
cd ./terraform/scripts/init-vpc
terraform init -var-file=../../secrets.tfvars
terraform apply -var-file=../../secrets.tfvars -auto-approve
VPC_ID=`terraform output vpc_id`
PRIVATE_SUBNET1=`terraform output private-subnet1_id`
PRIVATE_SUBNET2=`terraform output private-subnet2_id`
PUBLIC_SUBNET1=`terraform output public-subnet1_id`
PUBLIC_SUBNET2=`terraform output public-subnet2_id`

###############################
# Create a PostgreSQL DB######
#############################
#cd $HOME_PATH
#cd ./terraform/scripts/postgresql-db
#terraform init -var-file=../../secrets.tfvars -var "vpc_id=$VPC_ID" -var "private-subnet1_id=$PRIVATE_SUBNET1" -var "private-subnet2_id=$PRIVATE_SUBNET2"
#terraform apply -var-file=../../secrets.tfvars -var "vpc_id=$VPC_ID" -var "private-subnet1_id=$PRIVATE_SUBNET1" -var "private-subnet2_id=$PRIVATE_SUBNET2" -auto-approve
#DB_ENDPOINT_URL=`terraform output endpoint`

###############################
### Create AMI image #########
#############################
cd $HOME_PATH
cd ./packer
#sed -i '' "s/DB_ENDPOINT/${DB_ENDPOINT_URL}/" data/sample.html
packer build -machine-readable aws_ami_nginx.json | tee build.log
AMI_ID=`egrep -oe 'ami-.{17}' build.log |tail -n1`
echo 'variable "AMI_ID" { default = "'${AMI_ID}'" }'

#################################
#### Application LB ############
###############################
cd $HOME_PATH
cd ./terraform/scripts/application-lb
terraform init -var-file=../../secrets.tfvars -var "vpc_id=$VPC_ID" -var "public_subnet1_id=$PUBLIC_SUBNET1" -var "public_subnet2_id=$PUBLIC_SUBNET2"
terraform apply -var-file=../../secrets.tfvars -var "vpc_id=$VPC_ID" -var "public_subnet1_id=$PUBLIC_SUBNET1" -var "public_subnet2_id=$PUBLIC_SUBNET2" -auto-approve
ALB_SG=`terraform output alb-securitygroup`
TARGET_GROUP=`terraform output target_group_arn`

#################################
#### AutoSclaing ###############
###############################
cd $HOME_PATH
cd ./terraform/scripts/ec2-instance
terraform init -var-file=../../secrets.tfvars -var "vpc_id=$VPC_ID" -var "public_subnet1_id=$PUBLIC_SUBNET1" -var "public_subnet2_id=$PUBLIC_SUBNET2" -var "target_group_arn=$TARGET_GROUP" -var "alb-securitygroup=$ALB_SG"
terraform apply -var-file=../../secrets.tfvars -var "vpc_id=$VPC_ID" -var "public_subnet1_id=$PUBLIC_SUBNET1" -var "public_subnet2_id=$PUBLIC_SUBNET2" -var "target_group_arn=$TARGET_GROUP" -var "alb-securitygroup=$ALB_SG" -auto-approve
