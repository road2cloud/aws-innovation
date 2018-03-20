pipeline {
    agent any

    //def inputFile == input message: 'Upload File', parameters: [file(name: 'MyNVirginiaKey.pem')]
    //writeFile(file: 'MyNVirginiaKey.pem', text: inputFile.readToString())

    stages {
        stage ('Build Infrastructure') {
          steps {
            wrap([$class: 'AnsiColorBuildWrapper', colorMapName: "xterm"]) {
              sh 'mv PEM_FILE ansible/MyNVirginiaKey.pem'
              sh '/Users/dimeh/Documents/workspace/pic/terraform/terraform init'
              sh "/Users/dimeh/Documents/workspace/pic/terraform/terraform apply -var 'access_key=${ACCESS_KEY}' -var 'secret_key=${SECRET_KEY}' -var 'aws_key_name=MyNVirginiaKey' -var 'project=${PROJECT}' -auto-approve"

              sh '/Users/dimeh/Documents/workspace/pic/terraform/terraform output bastion > ansible/inventory'
            }
          }
        }

        stage ('Configure Bastion') {
          steps {
            wrap([$class: 'AnsiColorBuildWrapper', colorMapName: "xterm"]) {
              sdir ('ansible') {
                sh 'ansible-playbook playbook.yml --extra-vars "project=${PROJECT}"'
              }
            }
          }
        }
    }
}
