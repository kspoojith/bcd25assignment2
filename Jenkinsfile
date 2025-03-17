pipeline {
    agent any

    environment {
        GIT_REPO = 'https://github.com/kspoojith/bcd25assignment2.git'
        SONARQUBE_SERVER = 'SonarQube'
        DOCKER_IMAGE_NAME = '2022bcd0025-leaderboard'
    }

    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'main', url: "${GIT_REPO}"
            }
        }

              stage('Restore Dependencies') {
            steps {
                bat 'dotnet restore'
            }
        }
        stage('Build') {
            steps {
                bat 'dotnet build --configuration Release --no-restore'
            }
        }
        stage('Test') {
            steps {
                bat 'dotnet test --no-restore --verbosity normal'
            }
        }

        //       stage('SonarQube Analysis') {
        //     environment {
        //         SONAR_SCANNER_HOME = tool 'sonar-scanner'
        //     }
        //     steps {
        //         withSonarQubeEnv("${SONARQUBE_SERVER}") {
        //             bat "${SONAR_SCANNER_HOME}/bin/sonar-scanner"
        //         }
        //     }
        // }

              stage('Docker Build') {
            steps {
                script {
                    bat 'docker build -t ${DOCKER_IMAGE_NAME} .'
                }
            }
        }

              stage('Docker Push') {
            steps {
                script {
                    docker.withRegistry('https://index.docker.io/v1/', 'docker-credentials') {
                        bat 'docker tag ${DOCKER_IMAGE_NAME} your-docker-username/${DOCKER_IMAGE_NAME}:latest'
                        bat 'docker push your-docker-username/${DOCKER_IMAGE_NAME}:latest'
                    }
                }
            }
        }
        stage('Deploy') {
            steps {
                script {
                    bat 'docker run -d -p 8080:80 --name game-leaderboard ${DOCKER_IMAGE_NAME}'
                }
            }
        }
    }
}

