pipeline {

    agent any

    environment {
        AWS_REGION = 'ap-south-1'
        ECR_REGISTRY = '532217001462.dkr.ecr.ap-south-1.amazonaws.com'
        ECR_REPOSITORY = 'boardgame-app'
        IMAGE_TAG = "${BUILD_NUMBER}"
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build & Test') {
            steps {
                dir('app') {
                    sh './mvnw clean test'
                }
            }
        }
        
        stage('SonarQube Analysis') {
            steps {
                dir('app') {
                // withSonarQubeEnv automatically injects SONAR_TOKEN if configured correctly in Jenkins
                    withSonarQubeEnv('SonarQube') { 
                        sh './mvnw sonar:sonar -Dsonar.projectKey=Boardgame'
                    }
                }
            }
        }

        stage('Quality Gate') {
            steps {
                timeout(time: 5, unit: 'MINUTES') {
                    waitForQualityGate abortPipeline: true
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                dir('app') {
                    sh """
                        docker build \
                        -t ${ECR_REGISTRY}/${ECR_REPOSITORY}:${IMAGE_TAG} .
                    """
                }
            }
        }

        stage('Login to ECR') {
            steps {
                sh """
                    aws ecr get-login-password \
                    --region ${AWS_REGION} | \
                    docker login \
                    --username AWS \
                    --password-stdin ${ECR_REGISTRY}
                """
            }
        }

        stage('Push Image') {
            steps {
                sh """
                    docker push \
                    ${ECR_REGISTRY}/${ECR_REPOSITORY}:${IMAGE_TAG}
                """
            }
        }
    }
}
