@Library("laravel-docker-shared-library") _
pipeline {
    agent any
    environment {
        PATH = "$PATH:/home/gauravkumar/.local/bin/docker-compose"
        DOCKERHUB_CREDENTIALS=credentials('gauravgn90_dockerhub_user')
        VERSION="v3"
        APP_URL="http://localhost:88"
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
                    echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin
                '''
            }
        }
        stage('Pulling docker images from docker hub') {
            steps {
                sh '''
                    docker pull gauravgn90/laravel_mysql_service:${VERSION}
                    docker pull gauravgn90/laravel_nginx_service:${VERSION}
                    docker pull gauravgn90/laravel_php_service:${VERSION}
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
                    ## docker-compose down -v && docker-compose up -d
                    docker-compose stop && docker-compose up -d
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
                sh 'curl --head "${APP_URL}"'
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
        }

        success {
            sh '''
                echo 'Sending email after successful build generation.'  
            '''  
            emailext to: "gaurav@example.com",
            subject: "SUCCESS CI: Project:: ${env.JOB_NAME} : ${env.BUILD_NUMBER}",
            body: "<b>Example</b><br>Project: ${env.JOB_NAME} <br>Build Number: ${env.BUILD_NUMBER} <br> URL build: <a href='${env.BUILD_URL}'>${env.BUILD_URL}</a><br>App Url: <a href='${APP_URL}'' target='_blank'>${APP_URL}</a>",
            mimeType: 'text/html',
            replyTo: ''
        }  
        
        failure {
            sh '''
                echo 'Sending email after failure in build generation.'  
            '''  
            emailext to: "gaurav@example.com",
            subject: "ERROR CI: Project:: ${env.JOB_NAME} : ${env.BUILD_NUMBER}",
            body: "<b>Example</b><br>Project: ${env.JOB_NAME} <br>Build Number: ${env.BUILD_NUMBER} <br> URL build: <a href='${env.BUILD_URL}'>${env.BUILD_URL}</a>",
            mimeType: 'text/html',
            replyTo: ''
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
        }  
    }
}