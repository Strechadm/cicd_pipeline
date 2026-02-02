@Library('cicd-shared-lib@main') _

pipeline {
  agent any

  environment {
    PATH = "/usr/local/bin:/opt/homebrew/bin:/usr/bin:/bin:/usr/sbin:/sbin"
    DOCKER_REPO = 'strechadm/cicd-pipeline'
    IMAGE_TAG   = 'v1.0'
  }

  stages {
    stage('Checkout') {
      steps { checkout scm }
    }

    stage('CI (SharedLib)') {
      steps {
        script {
          // ciPipeline має всередині: npm install/test, hadolint, docker login, build+push, trivy scan
          def builtImage = ciPipeline(
            dockerRepo: env.DOCKER_REPO,
            imageTag: env.IMAGE_TAG,
            dockerCredsId: 'docker-hub-creds'
          ) { image ->
            stage('Trigger Deploy') {
              if (env.BRANCH_NAME == 'main') {
                build job: 'Deploy_to_main', parameters: [string(name: 'IMAGE_TAG', value: env.IMAGE_TAG)]
              } else if (env.BRANCH_NAME == 'dev') {
                build job: 'Deploy_to_dev', parameters: [string(name: 'IMAGE_TAG', value: env.IMAGE_TAG)]
              } else {
                echo "Skip deploy for branch: ${env.BRANCH_NAME}"
              }
            }
          }

          echo "Built & pushed image: ${builtImage}"
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