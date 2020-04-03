pipeline{
    agent any
    stages{    
        stage('Build'){
            steps{
                sh './mvnw package'
            }
        }
        stage('Sonarcloud'){
            steps{
                sh './mvnw verify sonar:sonar'
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
