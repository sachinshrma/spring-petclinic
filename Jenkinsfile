pipeline{
    agent any
    stages{    
        stage('Build'){
            steps{
                //sh './mvnw package'
                    sh 'ls'
            }
        }
        stage('Code analysis'){
            steps{
                //sh './mvnw verify sonar:sonar'
                    sh 'ls'
            }
        }
        stage('Containerization'){
            steps{
                withCredentials([usernamePassword(credentialsId: 'docker-hub-creds', passwordVariable: 'password', usernameVariable: 'username')]) {
                //sh "docker login -u ${username} -p ${password}"
                //sh 'docker build -t sachinshrma/petclinic:1.0.0 .'
                //sh 'docker push sachinshrma/petclinic:1.0.0'
                        sh 'ls'
                }
            }
        }
        stage('Deploy'){
            steps{
                withCredentials([string(credentialsId: 'subscription_id', variable: 'subscription_id'), string(credentialsId: 'client_id', variable: 'client_id'), string(credentialsId: 'client_secret', variable: 'client_secret'), string(credentialsId: 'tenant_id', variable: 'tenant_id')]) {
                    dir('Terraform') {
                        sh 'terraform init -input=false'
                       // sh 'terraform destroy -var="subscription_id=${subscription_id}" -var="client_id=${client_id}" -var="client_secret=${client_secret}" -var="tenant_id=${tenant_id}" -input=false -auto-approve'
                        sh 'terraform apply -var="prefix=prod${BUILD_NUMBER}" -var="subscription_id=${subscription_id}" -var="client_id=${client_id}" -var="client_secret=${client_secret}" -var="tenant_id=${tenant_id}" -input=false -auto-approve'
                        sh 'terraform output'
                    }
                }
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
