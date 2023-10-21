pipeline {
    environment {
        IMAGE_NAME = "staticwebsite"
        IMAGE_TAG = "latest"
        CONTAINER = "website"
        CONTAINER_DYNOS_HEROKU = "web1"
        STAGING = "paterne-staging"
        PRODCUTION = "paterne-production"
        LOCALHOST_DOCKER_NETWORK = "127.17.0.1"
    }
    agent none
    
    stages {
        stage('Build image') {
            agent any
            steps {
                script {
                    sh 'docker build -t $IMAGE_NAME:$IMAGE_TAG .'
                }
            } 
        }
        stage('Run docker container based on build image') {
            agent any
            steps {
                script {
                    sh '''
                    docker run -d -p 3000:80 --name $CONTAINER ${IMAGE_NAME}:${IMAGE_TAG}
                    sleep 5
                    '''
                }
            } 
        }
        /* Just Replace the IP address of ENV var "LOCALHOST_DOCKER_NETWORK" with your own local Docker container IP */
        stage('Test image') {
            agent any
            steps {
                script {
                    sh 'curl http://$LOCALHOST_DOCKER_NETWORK:3000 | grep -q "Dimension"'
                }
            } 
        }
        
        stage('Clean container') {
            agent any
            steps {
                script {
                    sh '''
                    docker container stop $CONTAINER
                    docker container rm $CONTAINER
                    '''
                }
            } 
        }
        stage('Push image in STAGING and Deploy') {
            when {
                expression { GIT_BRANCH == 'origin/master'}
            }
            agent {
                docker {
                    image 'franela/dind'
                    args '-u root:root -v /var/run/docker.sock:/var/run/docker.sock'
                    }
            }
            environment {
                HEROKU_API_KEY = credentials('heroku_api_key')
            }
            steps {
                script {
                    sh '''
                    apk --no-cache add npm
                    npm install -g heroku
                    ls -l /var/run/docker.sock
                    docker ps
                    heroku container:login
                    heroku create $STAGING || echo "project already exist"
                    heroku container:push -a $STAGING $CONTAINER_DYNOS_HEROKU
                    heroku container:release -a $STAGING $CONTAINER_DYNOS_HEROKU
                    '''
                }
            } 
        }
        stage('Push image in PRODUCTION and Deploy') {
            when {
                expression { GIT_BRANCH == 'origin/master'}
            }
            agent {
                docker {
                    image 'franela/dind'
                    args '-u root:root -v /var/run/docker.sock:/var/run/docker.sock'
                    }
            }
            environment {
                HEROKU_API_KEY = credentials('heroku_api_key')
            }
            steps {
                script {
                    sh '''
                    apk --no-cache add npm
                    npm install -g heroku
                    ls -l /var/run/docker.sock
                    docker ps
                    heroku container:login
                    heroku create $PRODCUTION || echo "project already exist"
                    heroku container:push -a $PRODCUTION $CONTAINER_DYNOS_HEROKU
                    heroku container:release -a $PRODCUTION $CONTAINER_DYNOS_HEROKU
                    '''
                }
            } 
        }
    }
}