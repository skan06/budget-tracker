pipeline {
    agent any

    environment {
        BACKEND_IMAGE = 'budget-tracker-backend:latest'
        FRONTEND_IMAGE = 'budget-tracker-frontend:latest'
        SONAR_TOKEN = credentials('sonar-token')
        GITHUB_CREDENTIALS = credentials('github-credentials')
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
                withSonarQubeEnv('sonarLocal') {
                    dir('backend') {
                        sh """
                        mvn sonar:sonar \
                          -Dsonar.projectKey=budget-tracker-backend \
                          -Dsonar.host.url=http://host.docker.internal:9000 \
                          -Dsonar.login=\$SONAR_TOKEN
                        """
                    }
                }
            }
        }

        stage('Verify JAR Exists') {
            steps {
                sh 'ls -la backend/target/'
            }
        }

        stage('Docker Build') {
            steps {
                sh "docker build --no-cache -t \$BACKEND_IMAGE -f backend/Dockerfile ."
                dir('frontend') {
                    sh "docker build --no-cache -t \$FRONTEND_IMAGE ."
                }
            }
        }

        stage('Load into Docker') {
            steps {
                sh 'docker save $BACKEND_IMAGE -o backend-image.tar'
                sh 'docker save $FRONTEND_IMAGE -o frontend-image.tar'

                sh 'docker load -i backend-image.tar'
                sh 'docker load -i frontend-image.tar'
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
                sh 'kubectl get services frontend'
            }
        }
    }

    post {
        success {
            echo "🎉 Pipeline succeeded!"
        }
        failure {
            echo "❌ pipeline failed!"
        }
    }
}