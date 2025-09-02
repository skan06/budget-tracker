pipeline {
    agent any

    environment {
        BACKEND_IMAGE = 'budget-tracker-backend:latest'
        FRONTEND_IMAGE = 'budget-tracker-frontend:latest'
        AWS_ACCOUNT_ID = '654654557455'
        AWS_REGION = 'us-east-1'
        ECR_REPO_BACKEND = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/budget-tracker-backend"
        ECR_REPO_FRONTEND = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/budget-tracker-frontend"
        IMAGE_URI_BACKEND = "${ECR_REPO_BACKEND}:latest"
        IMAGE_URI_FRONTEND = "${ECR_REPO_FRONTEND}:latest"
        SONAR_TOKEN = credentials('sonar-token')
        AWS_CREDS = credentials('aws-credentials')
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
                script {
                    withSonarQubeEnv('SonarLocal') {
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
        }

        stage('Docker Build') {
            steps {
                sh "docker build --no-cache -t \$BACKEND_IMAGE -f backend/Dockerfile ."
                dir('frontend') {
                    sh "docker build --no-cache -t \$FRONTEND_IMAGE ."
                }
            }
        }

        stage('Push to ECR') {
            steps {
                sh '''
                    export AWS_ACCESS_KEY_ID=${AWS_CREDS_USR}
                    export AWS_SECRET_ACCESS_KEY=${AWS_CREDS_PSW}
                    aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com
                    docker tag $BACKEND_IMAGE $IMAGE_URI_BACKEND
                    docker tag $FRONTEND_IMAGE $IMAGE_URI_FRONTEND
                    docker push $IMAGE_URI_BACKEND
                    docker push $IMAGE_URI_FRONTEND
                '''
            }
        }

        stage('Terraform Init & Plan') {
            steps {
                dir('terraform') {
                    sh 'terraform init'
                    sh 'terraform plan -out=tfplan -var="backend_image_uri=$IMAGE_URI_BACKEND" -var="frontend_image_uri=$IMAGE_URI_FRONTEND"'
                }
            }
        }

        stage('Security Scan - Checkov') {
            steps {
                dir('terraform') {
                    sh 'checkov -d . --quiet'
                }
            }
        }

        stage('Security Scan - Terrascan') {
            steps {
                dir('terraform') {
                    sh 'terrascan scan -d .'
                }
            }
        }

        stage('Apply Terraform') {
            steps {
                dir('terraform') {
                    sh 'terraform apply -auto-approve tfplan'
                }
            }
        }

        stage('Configure Kubectl') {
            steps {
                dir('terraform') {
                    sh 'aws eks update-kubeconfig --name budget-tracker-eks --region $AWS_REGION'
                }
            }
        }

        stage('Wait for EKS Ready') {
            steps {
                script {
                    sh '''
                        set +e
                        for i in {1..30}; do
                            kubectl get nodes > /dev/null 2>&1
                            if [ $? -eq 0 ]; then
                                echo "EKS cluster ready"
                                set -e
                                exit 0
                            fi
                            echo "Waiting for EKS cluster... ($i/30)"
                            sleep 30
                        done
                        echo "EKS cluster not ready after 15 minutes"
                        exit 1
                    '''
                }
            }
        }

        stage('Terratest') {
            steps {
                dir('tests/terratest') {
                    sh 'go mod tidy'
                    sh 'go test -v'
                }
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
                sh 'kubectl get service frontend-service'
            }
        }

        stage('Get Frontend URL') {
            steps {
                script {
                    def url = sh(
                        script: 'kubectl get service frontend-service -o jsonpath="{.status.loadBalancer.ingress[0].hostname}"',
                        returnStdout: true
                    ).trim()
                    if (url) {
                        echo "🎉 App is live at: http://${url}"
                    } else {
                        echo "⚠️  LoadBalancer not assigned yet"
                    }
                }
            }
        }
    }

    post {
        success {
            script {
                def url = sh(script: 'kubectl get service frontend-service -o jsonpath="{.status.loadBalancer.ingress[0].hostname}"', returnStdout: true).trim()
                if (url) {
                    echo "🎉 Pipeline succeeded! App URL: http://${url}"
                } else {
                    echo "✅ Pipeline succeeded! LoadBalancer pending..."
                }
            }
        }
        failure {
            echo "❌ Pipeline failed!"
        }
        always {
            cleanWs()
        }
    }
}