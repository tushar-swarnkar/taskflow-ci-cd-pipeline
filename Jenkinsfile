pipeline {

    agent any

    environment {
        APP_NAME = "task-flow"
        APP_PORT = "9000"

        IMAGE_REPO = "swarnkartushar/task-flow"
        IMAGE_TAG = "${env.BUILD_NUMBER}"

        APP_HOST = "65.2.132.72"
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build Maven') {
          steps {
            sh """
                    docker run --rm \
                    -v "\$PWD":/workspace \
                    -w /workspace \
                    maven:3.9-eclipse-temurin-17 \
                    mvn -q clean package -DskipTests
                """
            }
        }

        stage('Docker Build') {
            steps {
                sh """
                    docker build -t ${IMAGE_REPO}:${IMAGE_TAG} -t ${IMAGE_REPO}:latest .
                """
            }
        }

        stage('Docker Push') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', usernameVariable: 'USER', passwordVariable: 'PASS')]) {
                    sh """
                        echo "$PASS" | docker login -u "$USER" --password-stdin
                        docker push ${IMAGE_REPO}:${IMAGE_TAG}
                        docker push ${IMAGE_REPO}:latest
                    """
                }
            }
        }

        stage('Deploy to EC2') {
            steps {
                sshagent(['ec2-ssh']) {
                    sh """
                        ssh -o StrictHostKeyChecking=no ec2-user@${APP_HOST} '
                            docker pull ${IMAGE_REPO}:latest &&
                            docker rm -f ${APP_NAME} || true &&
                            docker run -d --name ${APP_NAME} \
                            -p ${APP_PORT}:${APP_PORT} \
                            -e APP_VERSION=${IMAGE_TAG} \
                            ${IMAGE_REPO}:latest
                        '
                    """
                }
            }
        }

        stage('Health Check') {
            steps {
                sh "curl -f http://${APP_HOST}:${APP_PORT}/api/health"
            }
        }
    }
}
