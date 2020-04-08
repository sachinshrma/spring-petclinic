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
                sh './mvnw verify sonar:sonar'
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
                sh 'cd Terraform'
                sh 'terraform init'
                sh 'terraform apply -var "subscription_id="" -var "client_id="" -var "client_secret="" -var "tenant_id="" '
                sh 'terraform output'
            }
        }
    }    
}
