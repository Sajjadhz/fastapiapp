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
        sh 'docker build -t $DOCKER_REGISTRY/$DOCKERHUB_CREDENTIALS_USR/fastapiapp:$BUILD_NUMBER-$GIT_COMMIT .'
      }
    }
    stage('Login') {
      steps {
        sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'
      }
    }
    stage('Push') {
      steps {
        sh 'docker push $DOCKER_REGISTRY/$DOCKERHUB_CREDENTIALS_USR/fastapiapp:$BUILD_NUMBER-$GIT_COMMIT'
      }
    }
  }
  post {
    always {
      sh 'docker logout'
    }
  }
}