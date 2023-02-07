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
        sh 'docker build -t sajjadhz/fastapiapp:latest .'
      }
    }
    stage('Login') {
      steps {
        sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'
      }
    }
    stage('Push') {
      steps {
        sh 'docker push sajjadhz/fastapiapp:latest'
      }
    }
  }
  post {
    always {
      sh 'docker logout'
    }
  }
}