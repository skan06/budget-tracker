pipeline {
    agent any

    environment {
        // App & Image Names
        BACKEND_IMAGE = 'budget-tracker-backend:latest'
        FRONTEND_IMAGE = 'budget-tracker-frontend:latest'

        // SonarQube
        SONAR_TOKEN = credentials('sonar-token')  // Create this in Jenkins Credentials
        SONARQUBE_URL = 'http://localhost:9000'

        // Minikube & Kubectl
        MINIKUBE_HOME = '/home/jenkins/.minikube'
        KUBECONFIG = '/home/jenkins/.kube/config'
    }

    stages {
        stage('Clone Repository') {
            steps {
                script {
                    echo "🔍 Cloning GitHub repository..."
                    git branch: 'main',
                         url: 'https://github.com/skan06/budget-tracker.git'
                }
            }
        }

        stage('Build Backend') {
            steps {
                script {
                    echo "🛠️ Building Spring Boot backend..."
                    dir('backend') {
                        sh 'mvn clean package -DskipTests'
                    }
                }
            }
        }

        stage('Build Frontend') {
            steps {
                script {
                    echo "🛠️ Building Angular frontend..."
                    dir('frontend') {
                        sh 'npm install'
                        sh 'npx ng build --configuration production'
                    }
                }
            }
        }

        stage('SonarQube Analysis') {
            steps {
                script {
                    echo "🔍 Running SonarQube code quality analysis..."
                    withSonarQubeEnv('SonarLocal') {
                        sh '''
                        cd backend
                        mvn sonar:sonar \
                          -Dsonar.projectKey=budget-tracker-backend \
                          -Dsonar.projectName="Budget Tracker Backend" \
                          -Dsonar.host.url=http://localhost:9000 \
                          -Dsonar.login=${SONAR_TOKEN}
                        '''
                    }
                }
            }
        }

        stage('SonarQube Quality Gate') {
            steps {
                script {
                    echo "✅ Waiting for SonarQube Quality Gate..."
                    timeout(time: 5, unit: 'MINUTES') {
                        def qg = waitForQualityGate()
                        if (qg.status != 'OK') {
                            error "❌ SonarQube Quality Gate failed: ${qg.status}"
                        }
                    }
                }
            }
        }

        stage('Docker Build') {
            steps {
                script {
                    echo "🐳 Building Docker images..."
                    sh 'docker build -t ${BACKEND_IMAGE} -f backend/Dockerfile .'
                    sh 'docker build -t ${FRONTEND_IMAGE} -f frontend/Dockerfile .'
                }
            }
        }

        stage('Load Images into Minikube') {
            steps {
                script {
                    echo "📦 Loading Docker images into Minikube..."
                    sh 'docker save ${BACKEND_IMAGE} -o backend-image.tar'
                    sh 'docker save ${FRONTEND_IMAGE} -o frontend-image.tar'

                    sh 'minikube cp backend-image.tar /tmp/backend-image.tar'
                    sh 'minikube cp frontend-image.tar /tmp/frontend-image.tar'

                    sh 'minikube ssh "docker load -i /tmp/backend-image.tar"'
                    sh 'minikube ssh "docker load -i /tmp/frontend-image.tar"'

                    // Cleanup
                    sh 'rm -f backend-image.tar frontend-image.tar'
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                script {
                    echo "🚀 Deploying to Kubernetes (Minikube)..."
                    sh 'kubectl apply -f kubernetes/postgres-statefulset.yaml'
                    sh 'kubectl apply -f kubernetes/backend-deployment.yaml'
                    sh 'kubectl apply -f kubernetes/frontend-deployment.yaml'

                    echo "⏳ Waiting for deployments to be ready..."
                    sh 'kubectl rollout status deployment/backend --timeout=60s'
                    sh 'kubectl rollout status deployment/frontend --timeout=60s'
                    sh 'kubectl rollout status statefulset/postgres --timeout=60s'
                }
            }
        }

        stage('Verify Deployment') {
            steps {
                script {
                    echo "✅ Checking frontend service URL..."
                    sh 'minikube service frontend-service --url'
                }
            }
        }
    }

    post {
        success {
            echo "🎉 Pipeline succeeded! Your app is live on Minikube."
            sh '''
            echo "🌐 Access your app at:"
            minikube service frontend-service --url
            '''
        }
        failure {
            echo "❌ Pipeline failed. Check logs above."
        }
        always {
            echo "🧹 Ensuring cleanup..."
            sh 'rm -f backend-image.tar frontend-image.tar || true'
        }
    }
}