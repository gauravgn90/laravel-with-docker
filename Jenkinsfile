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
        stage('Prune Docker Data') {
            steps {
                sh '''
                    docker system prune -a --volumes -f
                    docker-compose down --remove-orphans -v
                '''
            }
            post {
                success {
                }
                failure {
                    script{
                        sh "exit 1"
                        //or
                        error "Failed, exiting now..."
                    }
                }
                aborted {
                }
                unstable {
                    script{
                           sh "exit 1"
                          //or
                          error "Unstable, exiting now..."                    
                     }
                }
            }
        }
        stage('Pulling docker images from docker hub') {
            steps {
                sh '''
                    docker pull gauravgn90/laravel_mysql_service:v1
                    docker pull gauravgn90/laravel_nginx_service:v1
                    docker pull gauravgn90/laravel_php_service:v1
                '''
            }
            post {
                success {
                }
                failure {
                    script{
                        sh "exit 1"
                        //or
                        error "Failed, exiting now..."
                    }
                }
                aborted {
                }
                unstable {
                    script{
                           sh "exit 1"
                          //or
                          error "Unstable, exiting now..."                    
                     }
                }
            }
        }
        stage("Start Container") {
            steps {
               sh '''
                    ls -ll
                    docker-compose down -v && docker-compose up -d
                    sleep 15
                    docker exec app ls -ll
                '''
            }
            post {
                success {
                }
                failure {
                    script{
                        sh "exit 1"
                        //or
                        error "Failed, exiting now..."
                    }
                }
                aborted {
                }
                unstable {
                    script{
                           sh "exit 1"
                          //or
                          error "Unstable, exiting now..."                    
                     }
                }
            }
        }

        stage("Updating env file in PHP container") {
            steps {
                sh '''
                    docker exec app ls -ll
                    docker exec app php -v
                    docker exec app mv api/.env.example api/.env
                '''
            }
            post {
                success {
                }
                failure {
                    script{
                        sh "exit 1"
                        //or
                        error "Failed, exiting now..."
                    }
                }
                aborted {
                }
                unstable {
                    script{
                           sh "exit 1"
                          //or
                          error "Unstable, exiting now..."                    
                     }
                }
            }
        }

        stage("Running Composer Install") {
            steps {
                sh '''
                    docker exec app composer install --working-dir=/var/www/api 
                    docker exec app composer dump-autoload --working-dir=/var/www/api 
                '''
            }
            post {
                success {
                }
                failure {
                    script{
                        sh "exit 1"
                        //or
                        error "Failed, exiting now..."
                    }
                }
                aborted {
                }
                unstable {
                    script{
                           sh "exit 1"
                          //or
                          error "Unstable, exiting now..."                    
                     }
                }
            }
        }

        stage("Validating Laravel Artisan Command and Generate App Key") {
            steps {
                sh '''
                    docker exec app php api/artisan
                    docker exec app php api/artisan key:generate 
                '''
            }
            post {
                success {
                }
                failure {
                    script{
                        sh "exit 1"
                        //or
                        error "Failed, exiting now..."
                    }
                }
                aborted {
                }
                unstable {
                    script{
                           sh "exit 1"
                          //or
                          error "Unstable, exiting now..."                    
                     }
                }
            }
        }
        stage("Run Laravel App Migrations") {
            steps {
                sh '''
                    docker exec app php api/artisan migrate
                '''
            }
            post {
                success {
                }
                failure {
                    script{
                        sh "exit 1"
                        //or
                        error "Failed, exiting now..."
                    }
                }
                aborted {
                }
                unstable {
                    script{
                           sh "exit 1"
                          //or
                          error "Unstable, exiting now..."                    
                     }
                }
            }
        }
        stage("Set Storage Permissions -1") {
            steps {
                sh '''
                    docker exec app bash -c "chmod -R 777 api/storage"
                '''
            }
            post {
                success {
                }
                failure {
                    script{
                        sh "exit 1"
                        //or
                        error "Failed, exiting now..."
                    }
                }
                aborted {
                }
                unstable {
                    script{
                           sh "exit 1"
                          //or
                          error "Unstable, exiting now..."                    
                     }
                }
            }
        }
        stage("Run Laravel App Test Cases") {
            steps {
                sh '''
                    docker exec app php api/vendor/bin/phpunit api/tests/Unit/
                    docker exec app php api/vendor/bin/phpunit api/tests/Feature/
                '''
            }
            post {
                success {
                }
                failure {
                    script{
                        sh "exit 1"
                        //or
                        error "Failed, exiting now..."
                    }
                }
                aborted {
                }
                unstable {
                    script{
                           sh "exit 1"
                          //or
                          error "Unstable, exiting now..."                    
                     }
                }
            }
        }
        stage("Set Storage Permissions -2") {
            steps {
                sh '''
                    docker exec app bash -c "chmod -R 777 api/storage"
                '''
            }
            post {
                success {
                }
                failure {
                    script{
                        sh "exit 1"
                        //or
                        error "Failed, exiting now..."
                    }
                }
                aborted {
                }
                unstable {
                    script{
                           sh "exit 1"
                          //or
                          error "Unstable, exiting now..."                    
                     }
                }
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