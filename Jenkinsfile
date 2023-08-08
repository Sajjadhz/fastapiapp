pipeline {
  agent any
  options {
    buildDiscarder(logRotator(numToKeepStr: '5'))
  }
  environment {
    DOCKERHUB_CREDENTIALS = credentials('sajjad-dockerhub')
    DOCKER_REGISTRY = 'docker.io'
    GIT_CMT_SHORT = "${GIT_COMMIT.take(7)}"
  }
  stages {
    stage('Build') {
      steps {
        sh 'docker build -t $DOCKER_REGISTRY/$DOCKERHUB_CREDENTIALS_USR/fastapiapp:$BUILD_NUMBER-$GIT_CMT_SHORT .'
      }
    }
    stage('Login') {
      steps {
        sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'
      }
    }
    stage('Push') {
      steps {
        sh 'docker push $DOCKER_REGISTRY/$DOCKERHUB_CREDENTIALS_USR/fastapiapp:$BUILD_NUMBER-$GIT_CMT_SHORT'
      }
    }    
    stage('Apply Kubernetes Files') {
      steps {
          withKubeConfig([credentialsId: 'kubeconfig']) {
          sh 'kubectl apply -f manifests/deployment-fastapiapp.yaml'
          sh 'kubectl apply -f manifests/service-fastapiapp.yaml'
        }
      }
  }
  }
  post {
    always {
      sh 'docker logout'
    }
  }
}