pipeline{
    agent any
    stages{    
        stage('Build'){
            steps{
                sh './mvnw package'
            }
        }
        stage('Code analysis'){
            steps{
                //sh './mvnw verify sonar:sonar'
            }
        }
        stage('Containerization'){
            steps{
                withCredentials([usernamePassword(credentialsId: 'docker-hub-creds', passwordVariable: 'password', usernameVariable: 'username')]) {
                sh "docker login -u ${username} -p ${password}"
                sh 'docker build -t sachinshrma/petclinic:1.0.0 .'
                sh 'docker push sachinshrma/petclinic:1.0.0'
                }
            }
        }
        stage('Deploy'){
            steps{
                withCredentials([string(credentialsId: 'subscription_id', variable: 'subscription_id'), string(credentialsId: 'client_id', variable: 'client_id'), string(credentialsId: 'client_secret', variable: 'client_secret'), string(credentialsId: 'tenant_id', variable: 'tenant_id')]) {
                    sh 'ls'
                    sh 'cd Terraform'
                    sh 'terraform init'
                    sh 'terraform apply -var="subscription_id=${subscription_id}" -var="client_id=${client_id}" -var="client_secret=${client_secret}" -var="tenant_id=${tenant_id}" '
                    sh 'terraform output'
                }
               
            }
        }
    }    
}
