pipeline {
  agent any
  options {
    buildDiscarder(logRotator(numToKeepStr: '5'))
  }
  environment {
    DOCKERHUB_CREDENTIALS = credentials('sajjad-dockerhub')
    DOCKER_REGISTRY = 'docker.io'
  }
  stages {
    stage('Build') {
      steps {
        sh '''
        echo start
        ${GIT_COMMIT:0:8}
        echo $GIT_COMMIT[0..7]
        echo $GIT_COMMIT.take(7)
        echo end
        '''
      }
    }
  }  
}