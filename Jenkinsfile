pipeline {
    agent any
    environment {
        PATH = "$PATH:/home/gauravkumar/.local/bin/docker-compose"
    }
   
    stages {
        stage("User Name") {
            steps {
                sh '''
                    whoami
                    groups
                '''
            }
        }
        stage("Verify Tooling") {
            steps {
                sh '''
                    docker version
                    docker info
                    docker-compose --version
                    curl --version
                    jq --version
                ''' 
            }
        }
        // stage('Prune Docker Data') {
        //     steps {
        //         sh 'docker system prune -a --volumes -f'
        //     }
        // }
        stage("Start Container") {
            steps {
               sh '''
                    ls -ll
                    docker-compose down -v && docker-compose build --no-cache && docker-compose up -d
                    sleep 15
                    docker exec app ls -ll
                    docker exec app php -v
                    docker exec app ls -l api
                '''
            }
        }
        stage('Run tests againts container') {
            steps {
                sh "curl http://localhost:88"
            }
        }
    }

    // post {
    //     always {
    //         sh 'docker-compose down --remove-orphans -v'
    //         sh 'docker-compose ps'
    //     }
    // }
}