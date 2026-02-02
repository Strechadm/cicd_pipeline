pipeline {
  agent any

  parameters {
    string(name: 'IMAGE_TAG', defaultValue: 'v1.0', description: 'Docker image tag')
  }

  environment {
    PATH            = "/usr/local/bin:/opt/homebrew/bin:/usr/bin:/bin:/usr/sbin:/sbin"
    DOCKER_CREDS_ID = 'docker-hub-creds'
    DOCKER_REPO     = 'strechadm/cicd-pipeline'
  }

  stages {
    stage('Login & Pull') {
      steps {
        withCredentials([usernamePassword(credentialsId: env.DOCKER_CREDS_ID, usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
          sh 'echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin'
        }
        sh "docker pull ${DOCKER_REPO}:dev-${params.IMAGE_TAG}"
      }
    }

    stage('Stop only DEV container') {
      steps {
        sh 'docker rm -f node-dev 2>/dev/null || true'
      }
    }

    stage('Run') {
      steps {
        sh """
          docker run -d --name node-dev \
            -p 3001:3000 \
            ${DOCKER_REPO}:dev-${params.IMAGE_TAG}
        """
      }
    }
  }

  post {
    always { sh 'docker logout || true' }
  }
}