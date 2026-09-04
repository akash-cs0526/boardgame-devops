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
            environment {
                JAVA_HOME = '/usr/lib/jvm/java-1.11.0-openjdk-amd64'
                PATH      = "${env.JAVA_HOME}/bin:${env.PATH}"
            }
            steps {
                dir('app') {
                    // Give the Maven wrapper script execution rights
                    sh 'chmod +x ./mvnw'
                    sh './mvnw clean package -DskipTests'
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

        stage('Deploy') {
            steps {
                sshagent(['boardgame-ec2-ssh']) {
                    sh """
                        ansible-playbook \
                        -i ansible/inventory \
                        ansible/deploy.yml \
                        -e "image_tag=${IMAGE_TAG}"
                    """
                }
            }
        }
    }
}
