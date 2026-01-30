pipeline {
  agent any
  tools {
    nodejs 'node-20'
  }

  environment {
    // branch name in multibranch: main/dev
    BR = "${env.BRANCH_NAME}"
    PORT = "${env.BRANCH_NAME == 'main' ? '3000' : '3001'}"
    IMAGE = "${env.BRANCH_NAME == 'main' ? 'nodemain:v1.0' : 'nodedev:v1.0'}"
    CONTAINER = "app_${env.BRANCH_NAME}"
  }

  stages {
    stage('Checkout') {
      steps {
        checkout scm
        sh 'echo "Branch: $BR"'
      }
    }

    stage('Build') {
      steps {
        sh 'chmod +x scripts/build.sh || true'
        sh './scripts/build.sh || npm install'
      }
    }

    stage('Test') {
      steps {
        sh 'chmod +x scripts/test.sh || true'
        sh './scripts/test.sh || npm test || true'
      }
    }

    stage('Build Docker Image') {
      steps {
        sh 'docker version'
        sh 'docker build -t $IMAGE .'
      }
    }

    stage('Deploy') {
      steps {
        sh '''
          set -e
          echo "Deploying $BR on port $PORT using image $IMAGE"
          docker rm -f "$CONTAINER" 2>/dev/null || true
          docker run -d --name "$CONTAINER" -p "$PORT:3000" "$IMAGE"
          docker ps --filter "name=$CONTAINER"
        '''
      }
    }
  }
}