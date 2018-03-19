pipeline {
    agent any

    stages {

        stage ('Deploy to EC2') {
          steps {
            wrap([$class: 'AnsiColorBuildWrapper', colorMapName: "xterm"]) {
              sh '/Users/dimeh/Documents/workspace/pic/terraform/terraform apply -auto-approve'
            }
          }
        }

    }
}
