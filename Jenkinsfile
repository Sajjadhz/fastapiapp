pipeline {
  agent any
  options {
    buildDiscarder(logRotator(numToKeepStr: '5'))
  }
  environment {
    DOCKERHUB_CREDENTIALS = credentials('sajjad-dockerhub')
    DOCKER_REGISTRY = 'docker.io'
    GIT_CMT_SHORT_1 = "${GIT_COMMIT.take(7)}"
    GIT_CMT_SHORT_2 = "${GIT_COMMIT[0..7]}"
  }
  stages {
    stage('Build') {
      steps {
        sh '''
        echo start        
        echo $GIT_CMT_SHORT_1
        echo $GIT_CMT_SHORT_2
        echo end
        '''
      }
    }
  }  
}