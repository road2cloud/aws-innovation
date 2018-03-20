pipeline {
    agent any

    properties([
      disableConcurrentBuilds(),
      parameters([
        string(name: 'PROJECT', defaultValue: '', description: 'Name of the project for which the EC2 instance will be created'),
        file(name: 'PEM_FILE')
        ])
      ])

    //def inputFile == input message: 'Upload File', parameters: [file(name: 'MyNVirginiaKey.pem')]
    //writeFile(file: 'MyNVirginiaKey.pem', text: inputFile.readToString())
    sh 'mv PEM_FILE ansible/MyNVirginiaKey.pem'

    stages {
        stage ('Build Infrastructure') {
          steps {
            wrap([$class: 'AnsiColorBuildWrapper', colorMapName: "xterm"]) {
              sh './terraform init'
              sh './terraform apply -var-file="secrets.tfvars" -var 'project=${PROJECT}' -auto-approve'

              sh './terraform output bastion > ansible/inventory'
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
