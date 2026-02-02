pipeline {
  agent any

  environment {
    PATH = "/usr/local/bin:/opt/homebrew/bin:/usr/bin:/bin:/usr/sbin:/sbin"
    DOCKER_CREDS_ID = 'docker-hub-creds'
    DOCKER_REPO     = 'strechadm/cicd-pipeline'
    IMAGE_TAG       = 'v1.0'
  }

  stages {
    stage('Checkout') {
      steps { checkout scm }
    }

    stage('Build') {
      steps {
        sh 'npm install'
      }
    }

    stage('Test') {
      steps {
        sh 'npm test'
      }
    }

    stage('Docker Build') {
      steps {
        script {
          if (env.BRANCH_NAME == 'main') {
            env.FULL_IMAGE = "${DOCKER_REPO}:main-${IMAGE_TAG}"
          } else if (env.BRANCH_NAME == 'dev') {
            env.FULL_IMAGE = "${DOCKER_REPO}:dev-${IMAGE_TAG}"
          } else {
            error("Unsupported branch: ${env.BRANCH_NAME}. Only main/dev are allowed.")
          }

          sh "docker build -t ${env.FULL_IMAGE} ."
        }
      }
    }

    stage('Docker Login & Push') {
      steps {
        withCredentials([usernamePassword(credentialsId: env.DOCKER_CREDS_ID, usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
          sh '''
            echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
          '''
          sh "docker push ${env.FULL_IMAGE}"
        }
      }
    }

    stage('Trigger Deploy Job') {
      steps {
        script {
          if (env.BRANCH_NAME == 'main') {
            build job: 'Deploy_to_main', parameters: [
              string(name: 'IMAGE_TAG', value: env.IMAGE_TAG)
            ]
          } else if (env.BRANCH_NAME == 'dev') {
            build job: 'Deploy_to_dev', parameters: [
              string(name: 'IMAGE_TAG', value: env.IMAGE_TAG)
            ]
          }
        }
      }
    }
  }

  post {
    always {
      sh 'docker logout || true'
    }
  }
}