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
                git branch: 'main', url: 'https://github.com/skan06/budget-tracker.git'
            }
        }

        stage('Build Backend') {
            steps {
                dir('backend') {
                    sh 'mvn clean package -DskipTests'
                }
            }
        }

        stage('Build Frontend') {
            steps {
                dir('frontend') {
                    sh 'npm install'
                    sh 'npx ng build --configuration production'
                }
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('SonarLocal') {
                    sh '''
                    cd backend
                    mvn sonar:sonar \
                      -Dsonar.projectKey=budget-tracker-backend \
                      -Dsonar.host.url=http://localhost:9000 \
                      -Dsonar.login=${SONAR_TOKEN}
                    '''
                }
            }
        }

        stage('Docker Build') {
            steps {
                sh 'docker build -t ${BACKEND_IMAGE} -f backend/Dockerfile .'
                sh 'docker build -t ${FRONTEND_IMAGE} -f frontend/Dockerfile .'
            }
        }

        stage('Load into Minikube') {
            steps {
                sh 'docker save ${BACKEND_IMAGE} -o backend-image.tar'
                sh 'docker save ${FRONTEND_IMAGE} -o frontend-image.tar'

                sh 'minikube cp backend-image.tar /tmp/backend-image.tar'
                sh 'minikube cp frontend-image.tar /tmp/frontend-image.tar'

                sh 'minikube ssh "docker load -i /tmp/backend-image.tar"'
                sh 'minikube ssh "docker load -i /tmp/frontend-image.tar"'
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                sh 'kubectl apply -f kubernetes/postgres-statefulset.yaml'
                sh 'kubectl apply -f kubernetes/backend-deployment.yaml'
                sh 'kubectl apply -f kubernetes/frontend-deployment.yaml'

                sh 'kubectl rollout status deployment/backend --timeout=60s'
                sh 'kubectl rollout status deployment/frontend --timeout=60s'
            }
        }

        stage('Verify') {
            steps {
                sh 'minikube service frontend-service --url'
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