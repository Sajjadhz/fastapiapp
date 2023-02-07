pipeline {
  agent any
  options {
    buildDiscarder(logRotator(numToKeepStr: '5'))
  }
  environment {
    DOCKERHUB_CREDENTIALS = credentials('sajjadhz-dockerhub')
  }
  stages {
    stage('Build') {
      steps {
        sh 'echo DOCKERHUB_CREDENTIALS'
      }
    }
    stage('Login') {
      steps {
        sh 'echo $DOCKERHUB_CREDENTIALS_PSW'
      }
    }
    stage('Push') {
      steps {
        sh 'echo $DOCKERHUB_CREDENTIALS_USR'
      }
    }
  }
}