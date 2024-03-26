pipeline {
    agent {
        node {
            label 'AGENT-1'
        }
    }

    // parameters {
    //     choice(name: 'action', choices: ['apply', 'destroy'], description: 'Pick something')
    // }
    
    options {
        ansiColor('xterm')
        timeout(time: 1, unit: 'HOURS') 
        disableConcurrentBuilds() //It wont allow two builds at a time
    }

    
    //BUILD
    stages {
        stage('VPC') {
            steps {
                sh """
                    cd 01-vpc
                    terraform init -reconfigure
                    terraform apply -auto-approve
                """               
            }
        }

        stage('SG') {
            steps {
                sh """
                    cd 02-sg
                    terraform init -reconfigure
                    terraform apply -auto-approve
                """               
            }
        }

        stage('VPN') {
            steps {
                sh """
                    cd 03-vpn
                    terraform init -reconfigure
                    terraform apply -auto-approve
                """               
            }
        }

         stage('DB ALB') {
            parallel {
                stage('DB') {
                    steps {
                        sh """
                            cd 04-database
                            terraform init -reconfigure
                            terraform apply -auto-approve
                        """   
                    }
                }
                stage('APP ALB') {
                    steps {
                        sh """
                            cd 05-app-alb
                            terraform init -reconfigure
                            terraform apply -auto-approve
                        """   
                    }
                }
            }
        }       
         
    }

    // POST BUILD
    post { 
        always { 
            echo 'I will always say Hello!!'
        }

        failure { 
            echo 'this runs when pipeline is failed, used generally to send alerts'
        }
        success { 
            echo 'I will always say Hello when pipeline is success'
        }
    }
}