pipeline {
    agent any

    options {
      buildDiscarder(logRotator(numToKeepStr: '1'))
    }

    stages {
        stage ('Build Infrastructure') {
          steps {
            wrap([$class: 'AnsiColorBuildWrapper', colorMapName: "xterm"]) {
              // TODO: PATH TO TERRAFORM TO BE REMOVED
              sh '/Users/dimeh/Documents/workspace/pic/terraform/terraform init'
              sh "/Users/dimeh/Documents/workspace/pic/terraform/terraform ${ACTION} -var 'access_key=${ACCESS_KEY}' -var 'secret_key=${SECRET_KEY}' -var 'aws_key_name=MyNVirginiaKey' -var 'project=${PROJECT}' -auto-approve"
            }
          }
        }

        stage ('Configure Bastion') {
          when {
            environment name: 'ACTION', value: 'apply'
          }
          steps {
            wrap([$class: 'AnsiColorBuildWrapper', colorMapName: "xterm"]) {
              // sh '/Users/dimeh/Documents/workspace/pic/terraform/terraform output bastion > ansible/inventory'

              dir ('ansible') {
                // Remove since it was added to user .ssh
                // sh 'mv MyNVirginiaKey.pem MyNVirginiaKey.pem'
                // sh 'chmod 600 MyNVirginiaKey.pem'
                ansiblePlaybook(
                  playbook: 'playbook.yml',
                  inventory: 'inventory',
                  extras: '-e project="${PROJECT}"',
                  colorized: true)
              }
            }
          }
        }
    }
}
