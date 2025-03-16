pipeline {
    agent any

    environment {
        GIT_REPO = 'https://github.com/mehdihadeli/game-leaderboard-microservices.git'
        SONARQUBE_SERVER = 'SonarQube'
        DOCKER_IMAGE_NAME = 'game-leaderboard-microservices'
    }

    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'main', url: "${GIT_REPO}"
            }
        }
        // Additional stages will be added here
    }
}
