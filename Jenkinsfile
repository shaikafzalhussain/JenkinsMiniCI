pipeline {
    agent any

    stages {
        stage('Code Quality - SonarQube') {
            steps {
                withSonarQubeEnv('SonarQubeServer') {
                    sh 'sonar-scanner'
                }
            }
        }

        stage('Test') {
            steps {
                sh 'pytest --junitxml=report.xml --cov=. --cov-report=xml'
            }
            post {
                always {
                    junit 'report.xml'
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t yourdockerhubusername/python-jenkins-sonar:latest .'
            }
        }

        stage('Push to DockerHub') {
            steps {
                withCredentials([string(credentialsId: 'dockerhub-token', variable: 'DOCKER_TOKEN')]) {
                    sh '''
                    echo "$DOCKER_TOKEN" | docker login -u yourdockerhubusername --password-stdin
                    docker push yourdockerhubusername/python-jenkins-sonar:latest
                    '''
                }
            }
        }
    }
}
	
