pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "shaikafzalhussain/python-jenkins-sonar:${env.BUILD_NUMBER}"
    }

    stages {

        stage('Code Quality (SonarQube)') {
            steps {
                echo "🔍 Running SonarQube analysis..."
                withSonarQubeEnv('Sonar') {
                    dir('app') {
                        sh 'sonar-scanner'
                    }
                }
            }
        }

        stage('Unit Test + Coverage') {
            steps {
                echo "🧪 Running unit tests and coverage..."
                dir('app') {
                    sh '''
                    python3 -m venv venv
                    source venv/bin/activate
                    pip install --upgrade pip
                    pip install -r requirements.txt pytest pytest-cov
                    pytest --junitxml=report.xml --cov=. --cov-report=xml
                    '''
                }
            }
            post {
                always {
                    junit 'app/report.xml'
                }
            }
        }

        stage('Docker Build') {
            steps {
                echo "🐳 Building Docker image..."
                sh "docker build -t ${DOCKER_IMAGE} ."
            }
        }

        stage('Docker Push') {
            steps {
                echo "📦 Pushing Docker image to DockerHub..."
                withCredentials([usernamePassword(credentialsId: 'DockerHub', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh '''
                    echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
                    docker push ${DOCKER_IMAGE}
                    '''
                }
            }
        }
    }

    post {
        success {
            echo "✅ Pipeline completed successfully. Image pushed: ${DOCKER_IMAGE}"
        }
        failure {
            echo "❌ Pipeline failed. Check console logs for details."
        }
    }
}
