pipeline {
  agent any
  options {
    buildDiscarder(logRotator(numToKeepStr: '5'))
  }
  environment {
    DOCKERHUB_CREDENTIALS = credentials('sajjad-dockerhub')
    DOCKER_REGISTRY = 'docker.io'
    GIT_CMT_SHORT_1 = ${GIT_COMMIT}
    GIT_CMT_SHORT_2 = '$GIT_COMMIT'
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