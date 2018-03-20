pipeline {
    agent any

    //def inputFile == input message: 'Upload File', parameters: [file(name: 'MyNVirginiaKey.pem')]
    //writeFile(file: 'MyNVirginiaKey.pem', text: inputFile.readToString())

    stages {
        stage ('Build Infrastructure') {
          steps {
            wrap([$class: 'AnsiColorBuildWrapper', colorMapName: "xterm"]) {
              // TODO: TO BE REMOVED
              sh '/Users/dimeh/Documents/workspace/pic/terraform/terraform init'
              sh "/Users/dimeh/Documents/workspace/pic/terraform/terraform ${ACTION} -var 'access_key=${ACCESS_KEY}' -var 'secret_key=${SECRET_KEY}' -var 'aws_key_name=MyNVirginiaKey' -var 'project=${PROJECT}' -auto-approve"

              sh '/Users/dimeh/Documents/workspace/pic/terraform/terraform output bastion > ansible/inventory'
            }
          }
        }

        if (ACTION == 'apply') {
          stage ('Configure Bastion') {
            steps {
              wrap([$class: 'AnsiColorBuildWrapper', colorMapName: "xterm"]) {
                dir ('ansible') {
                  sh 'mv MyNVirginiaKey.pem MyNVirginiaKey.pem'
                  sh 'chmod 600 MyNVirginiaKey.pem'

                  ansiblePlaybook(
                    playbook: 'playbook.yml',
                    inventory: 'inventory',
                    extras: '-e project="${PROJECT}"',
                    colorized: true)

                  //sh 'ansible-playbook playbook.yml --extra-vars "project=${PROJECT}"'
                }
              }
            }
          }


      }
    }
}
