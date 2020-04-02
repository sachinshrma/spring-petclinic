pipeline{
    agent any
    
    stages{
        
        stage('SCM checkout'){
            steps{
                git 'https://github.com/sachinshrma/spring-petclinic'
            }
        }
        
        stage('Build'){
            steps{
                sh './mvnw package'
            }
        }
        stage('Deploy'){
            steps{
                withCredentials([usernamePassword(credentialsId: 'docker-hub-creds', passwordVariable: 'password', usernameVariable: 'username')]) {
                sh "docker login -u ${username} -p ${password}"
                sh 'docker build -t sachinshrma/petclinic:1.0.0 .'
                sh 'docker push sachinshrma/petclinic:1.0.0'
                }
            }
        }
    
    }
    
}
