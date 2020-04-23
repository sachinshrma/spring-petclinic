def imageVersion="1.0.${BUILD_NUMBER}"
pipeline{
    agent {label slave_agent}
    stages{    
        stage('Build'){
            steps{
                sh './mvnw package'
            }
        }
        stage('Code analysis'){
            steps{
                sh './mvnw verify sonar:sonar'
            }
        }
        stage('Containerization'){
            steps{
                withCredentials([usernamePassword(credentialsId: 'docker-hub-creds', passwordVariable: 'password', usernameVariable: 'username')]) {
                sh "docker login -u ${username} -p ${password}"
                sh "docker build -t sachinshrma/petclinic:${imageVersion} ."
                sh 'docker build -t sachinshrma/petclinic:latest .'
                sh "docker push sachinshrma/petclinic:${imageVersion}"
                sh 'docker push sachinshrma/petclinic:latest'
                }
            }
        }
        stage('Deploy'){
            steps{
                withCredentials([string(credentialsId: 'subscription_id', variable: 'subscription_id'), string(credentialsId: 'client_id', variable: 'client_id'), string(credentialsId: 'client_secret', variable: 'client_secret'), string(credentialsId: 'tenant_id', variable: 'tenant_id')]) {
                    dir('Terraform') {
                        sh 'terraform init -input=false'
                       // sh 'terraform destroy -var="subscription_id=${subscription_id}" -var="client_id=${client_id}" -var="client_secret=${client_secret}" -var="tenant_id=${tenant_id}" -input=false -auto-approve'
                        sh 'terraform apply -var="prefix=prod" -var="subscription_id=${subscription_id}" -var="client_id=${client_id}" -var="client_secret=${client_secret}" -var="tenant_id=${tenant_id}" -input=false -auto-approve'
                       // sh 'terraform output'
                    }
                }
                sh "kubectl set image deployment/petclinic-app webapp=sachinshrma/petclinic:${imageVersion}"
            }
        }
    }
    post {
        always {
			emailext (
                to: "sachinsharma9998@gmail.com",
                subject: '${DEFAULT_SUBJECT}',
                body: '${DEFAULT_CONTENT}',
            )
        }
    }
}
