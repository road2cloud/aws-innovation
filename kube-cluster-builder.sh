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
PUBLIC_SUBNET1=`terraform output public-subnet1_id`
PUBLIC_SUBNET2=`terraform output public-subnet2_id`

#################################
############ EKS ###############
###############################
cd $HOME_PATH
cd ./terraform/scripts/kubernetes
terraform init -var-file=../../secrets.tfvars -var "vpc_id=$VPC_ID" -var "public_subnet1_id=$PUBLIC_SUBNET1" -var "public_subnet2_id=$PUBLIC_SUBNET2"
terraform apply -var-file=../../secrets.tfvars -var "vpc_id=$VPC_ID" -var "public_subnet1_id=$PUBLIC_SUBNET1" -var "public_subnet2_id=$PUBLIC_SUBNET2" -auto-approve
