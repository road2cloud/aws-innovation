BUILD INFRA LOCALLY  
./terraform apply -var-file=secrets.tfvars -auto-approve  
<!-- ADD additional python module to support password generation -->  
ansible-playbook playbook.yml --extra-vars "project=aad"  

To CLEAN AWS  
./terraform destroy -var-file=secrets.tfvars -auto-approve  

MANDATORY FOR ANSIBLE TO WORK:  
RUN: ssh-add /path/to/pem/file  

TEST :  
ssh PROJECT-user@BASTION_IP  
ssh -i PROJECT-keypair.pem ec2-user@EC2_IP   
curl -4 http://wttr.in/paris  

Run terraform output config-map-aws-auth and save the configuration into a file, e.g.   config-map-aws-auth.yaml  
Run kubectl apply -f config-map-aws-auth.yaml  
You can verify the worker nodes are joining the cluster via: kubectl get nodes --watch  
