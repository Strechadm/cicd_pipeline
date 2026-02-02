@Library('cicd-shared-lib') _

pipeline {
  agent any

  environment {
    DOCKER_REPO = 'strechadm/cicd-pipeline'
    IMAGE_TAG   = 'v1.0'
  }

  stages {
    stage('Checkout') {
      steps { checkout scm }
    }

    stage('CI') {
      steps {
        script {
          def image = ciPipeline(
            dockerRepo: env.DOCKER_REPO,
            imageTag: env.IMAGE_TAG,
            dockerCredsId: 'docker-hub-creds'
          ) { builtImage ->
            stage('Trigger Deploy') {
              if (env.BRANCH_NAME == 'main') {
                build job: 'Deploy_to_main', parameters: [string(name: 'IMAGE_TAG', value: env.IMAGE_TAG)]
              } else if (env.BRANCH_NAME == 'dev') {
                build job: 'Deploy_to_dev', parameters: [string(name: 'IMAGE_TAG', value: env.IMAGE_TAG)]
              }
            }
          }
          echo "Built & pushed image: ${image}"
        }
      }
    }
  }

  post {
    always { sh 'docker logout || true' }
  }
}