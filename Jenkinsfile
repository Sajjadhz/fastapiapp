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
        sh 'echo env.GIT_COMMIT.take(7)'
      }
    }
    stage('Login') {
      steps {
        sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'
      }
    }
    stage('Push') {
      steps {
        sh 'echo $BUILD_NUMBER-env.GIT_COMMIT.take(7)'
      }
    }
  }
  post {
    always {
      sh 'docker logout'
    }
  }
}