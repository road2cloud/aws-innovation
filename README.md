Login to the bastio nas root an enable ssh using login/ passwod  
1. putting "PasswordAuthentication yes" in /etc/ssh/sshd_config  
2. service sshd reload  


./terraform apply -var-file=secrets.tfvars -auto-approve  
<!-- ADD additional python module to support password generation -->  
ansible-playbook playbook.yml --extra-vars "project=aad"

./terraform destroy -var-file=secrets.tfvars -auto-approve  


TEST :
ssh aad-user@BASTION_IP
ssh -i aad-keypair.pem ec2-user@EC2_IP  
curl -4 http://wttr.in/paris  
