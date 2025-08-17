pipeline {
    agent any

    environment {
        BACKEND_IMAGE = 'budget-tracker-backend:latest'
        FRONTEND_IMAGE = 'budget-tracker-frontend:latest'
        SONAR_TOKEN = credentials('sonar-token')
    }

    tools {
        maven 'Maven 3.9.11'
        nodejs 'Node 20'
    }

    stages {
        stage('Clone Repository') {
            steps {
                git branch: 'main',
                     url: 'https://github.com/skan06/budget-tracker.git',
                     credentialsId: 'github-credentials'
            }
        }

        stage('Build Backend') {
            steps {
                dir('backend') {
                    bat 'mvn clean package -DskipTests'
                }
            }
        }

        stage('Build Frontend') {
            steps {
                dir('frontend') {
                    bat 'npm install'
                    bat 'npx ng build --configuration production'
                }
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('SonarLocal') {
                    dir('backend') {
                        bat '''
                        mvn sonar:sonar ^
                          -Dsonar.projectKey=budget-tracker-backend ^
                          -Dsonar.host.url=http://localhost:9000 ^
                          -Dsonar.login=%SONAR_TOKEN%
                        '''
                    }
                }
            }
        }

        stage('Verify JAR Exists') {
            steps {
                bat 'dir backend\\target'
            }
        }

        stage('Docker Build') {
            steps {
                bat "docker build --no-cache -t %BACKEND_IMAGE% -f backend/Dockerfile ."
                dir('frontend') {
                    bat "docker build --no-cache -t %FRONTEND_IMAGE% ."
                }
            }
        }

        stage('Load into Minikube') {
            steps {
                bat 'docker save %BACKEND_IMAGE% -o backend-image.tar'
                bat 'docker save %FRONTEND_IMAGE% -o frontend-image.tar'

                bat 'minikube cp backend-image.tar /tmp/backend-image.tar'
                bat 'minikube cp frontend-image.tar /tmp/frontend-image.tar'

                bat 'minikube ssh "docker load -i /tmp/backend-image.tar"'
                bat 'minikube ssh "docker load -i /tmp/frontend-image.tar"'
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                bat 'kubectl apply -f kubernetes/postgres-statefulset.yaml'
                bat 'kubectl apply -f kubernetes/backend-deployment.yaml'
                bat 'kubectl apply -f kubernetes/frontend-deployment.yaml'

                bat 'kubectl rollout status deployment/backend --timeout=60s'
                bat 'kubectl rollout status deployment/frontend --timeout=60s'
            }
        }

        stage('Verify') {
            steps {
                bat 'minikube service frontend-service --url'
            }
        }
    }

    post {
        success {
            echo "🎉 Pipeline succeeded!"
        }
        failure {
            echo "❌ Pipeline failed!"
        }
    }
}