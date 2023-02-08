pipeline {
  agent any
  options {
    buildDiscarder(logRotator(numToKeepStr: '5'))
  }
  environment {
    DOCKERHUB_CREDENTIALS = credentials('sajjad-dockerhub')
    DOCKER_REGISTRY = 'sajjadhz'
  }
  stages {
    stage('Build') {
      steps {
        sh 'docker build -t $DOCKER_REGISTRY/fastapiapp:latest .'
      }
    }
    stage('Login') {
      steps {
        sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'
      }
    }
    stage('Push') {
      steps {
        sh 'docker push $DOCKER_REGISTRY/fastapiapp:latest'
      }
    }
  }
  post {
    always {
      sh 'docker logout'
    }
  }
}