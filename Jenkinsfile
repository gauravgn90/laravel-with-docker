@Library("laravel-docker-shared-library") _
pipeline {
    agent any
    environment {
        PATH = "$PATH:/home/gauravkumar/.local/bin/docker-compose"
        dockerhub=credentials('gauravgn90_dockerhub_user')
    }
   
    stages {
        stage("User Name") {
            steps {
                sh '''
                    whoami
                    newgrp docker
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
        stage("Laravel Jenkins Shared Lib") {
            steps {
                helloJenkins()
            }
        }
        stage('Prune Docker Data') {
            steps {
                sh '''
                    # docker system prune -a --volumes -f
                    # docker-compose down --remove-orphans -v
                '''
            }
            post {
                failure {
                    script{
                        sh "exit 1"
                        //or
                        //error "Failed, exiting now..."
                    }
                }
                unstable {
                    script{
                           sh "exit 1"
                          //or
                          // error "Unstable, exiting now..."                    
                     }
                }
            }
        }
        stage("Checking Docker Credentilas") {
            steps {
                sh '''
                    echo $dockerhub_PSW | docker login -u $dockerhub_USR --password-stdin
                '''
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
                failure {
                    script{
                        sh "exit 1"
                        //or
                        //error "Failed, exiting now..."
                    }
                }
                unstable {
                    script{
                           sh "exit 1"
                          //or
                          // error "Unstable, exiting now..."                    
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
                failure {
                    script{
                        sh "exit 1"
                        //or
                        //error "Failed, exiting now..."
                    }
                }
                unstable {
                    script{
                           sh "exit 1"
                          //or
                          // error "Unstable, exiting now..."                    
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
                failure {
                    script{
                        sh "exit 1"
                        //or
                        //error "Failed, exiting now..."
                    }
                }
                unstable {
                    script{
                           sh "exit 1"
                          //or
                          // error "Unstable, exiting now..."                    
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
                failure {
                    script{
                        sh "exit 1"
                        //or
                        //error "Failed, exiting now..."
                    }
                }
                unstable {
                    script{
                           sh "exit 1"
                          //or
                          // error "Unstable, exiting now..."                    
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
                failure {
                    script{
                        sh "exit 1"
                        //or
                        //error "Failed, exiting now..."
                    }
                }
                unstable {
                    script{
                           sh "exit 1"
                          //or
                          // error "Unstable, exiting now..."                    
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
                failure {
                    script{
                        sh "exit 1"
                        //or
                        //error "Failed, exiting now..."
                    }
                }
                unstable {
                    script{
                           sh "exit 1"
                          //or
                          // error "Unstable, exiting now..."                    
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
                failure {
                    script{
                        sh "exit 1"
                        //or
                        //error "Failed, exiting now..."
                    }
                }
                unstable {
                    script{
                           sh "exit 1"
                          //or
                          // error "Unstable, exiting now..."                    
                     }
                }
            }
        }
        stage("Run Laravel App Test Cases") {
            steps {
                sh '''
                    docker exec app php api/vendor/bin/phpunit api/tests/Unit/*
                    docker exec app php api/vendor/bin/phpunit api/tests/Feature/*
                '''
            }
            post {
                success {
                    script {
                        sh 'echo "All test cases are passed!"'
                    }
                }
                failure {
                    script{
                        sh "exit 1"
                        //or
                        //// error "Failed, exiting now..."
                    }
                }
                unstable {
                    script{
                        sh "exit 1"
                        //or
                        // error "Unstable, exiting now..."                    
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
                failure {
                    script{
                        sh "exit 1"
                        //or
                        //error "Failed, exiting now..."
                    }
                }
                unstable {
                    script{
                           sh "exit 1"
                          //or
                          // error "Unstable, exiting now..."                    
                     }
                }
            }
        }
        stage('Validate App Is Up & Running') {
            steps {
                sh 'curl --head "http://localhost:88"'
            }
        }
        stage('Build Id and Build URL') {
            steps {
                sh '''
                    echo "Build Id for this Job is ${BUILD_ID}"
                    echo "Build URL for this Job is ${BUILD_URL}"
                '''
            }
        }
    }
    post {
        always {
            /* sh 'docker-compose down --remove-orphans -v'
            sh 'docker-compose ps' */
            sh '''
                echo 'This will always run'  
            '''

            emailext to: "naivetechblog@gmail.com",
            subject: "Test Email",
            body: "Test"
        }

       /*  success {
            sh '''
                echo 'This will run only if successful'  
                mail bcc: '', body: "<b>Example</b><br>Project: ${env.JOB_NAME} <br>Build Number: ${env.BUILD_NUMBER} <br> URL de build: ${env.BUILD_URL}", cc: '', charset: 'UTF-8', from: '', mimeType: 'text/html', replyTo: '', subject: "SUCCESS CI: Project name -> ${env.JOB_NAME}", to: "gaurav@example.com"
            '''  
        }  
        
        failure {
            sh '''
                mail bcc: '', body: "<b>Example</b><br>Project: ${env.JOB_NAME} <br>Build Number: ${env.BUILD_NUMBER} <br> URL de build: ${env.BUILD_URL}", cc: '', charset: 'UTF-8', from: '', mimeType: 'text/html', replyTo: '', subject: "ERROR CI: Project name -> ${env.JOB_NAME}", to: "gaurav@example.com"  
            '''  
        }

        unstable {  
            sh '''
                echo 'This will run only if the run was marked as unstable'  
            '''
        }

        changed {  
            sh '''
                echo 'This will run only if the state of the Pipeline has changed'  
                echo 'For example, if the Pipeline was previously failing but is now successful'  
            '''
        } */  
    }
}