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
        sh 'echo ${GIT_COMMIT,length=6}'
      }
    }
    stage('Login') {
      steps {
        sh 'echo ${GIT_COMMIT[0..7]}'
      }
    }
    stage('Push') {
      steps {
        sh 'echo $BUILD_NUMBER-GIT_COMMIT.take(7)'
      }
    }
  }
  post {
    always {
      sh 'docker logout'
    }
  }
}