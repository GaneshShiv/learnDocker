pipeline {
    agent any
	environment {
        registry = "ganeshshiv/learndocker"
        registryCredential = 'dockerhub'
        k8Container = 'learn-docker-k8s'
        k8Deployment = 'learn-docker'
    }
    stages {
        stage('Fetch Code') {
            steps {
                git branch: 'master', url: 'https://github.com/GaneshShiv/learnDocker.git'
            }
        }
        stage('Build') {
            steps {
                sh 'mvn clean install -DskipTests'
            }
        }

        stage('Unit Test') {
            steps{
                sh 'mvn test'
            }
        }
        
        stage('Checkstyle Analysis'){
            steps {
                sh 'mvn checkstyle:checkstyle'
            }
        }
        
      // stage('Sonar Analysis') {
      //      environment {
      //          scannerHome = tool 'sonar4.7'
      //      }
      //     steps {
      //         withSonarQubeEnv('sonar') {
      //             sh '''${scannerHome}/bin/sonar-scanner -Dsonar.projectKey=learndocker \
      //             -Dsonar.projectName=learndocker \
      //             -Dsonar.projectVersion=1.0 \
      //             -Dsonar.sources=src/ \
      //             -Dsonar.java.binaries=target/test-classes/com/siggma/learndocker/ \
      //             -Dsonar.junit.reportsPath=target/surefire-reports/ \
      //             -Dsonar.jacoco.reportsPath=target/jacoco.exec \
      //             -Dsonar.java.checkstyle.reportPaths=target/checkstyle-result.xml'''
      //        }
      //      }
      //  }
        stage('Build docker image'){
            steps{
                script{
                    //sh 'docker build -t learndocker_$BUILD_NUMBER .'
                    dockerImage = docker.build registry + ":$BUILD_NUMBER"
                }
            }
        }
        
        stage('Publish Image') {
          steps{
            script {
              docker.withRegistry( '', registryCredential ) {
                dockerImage.push("$BUILD_NUMBER")
                dockerImage.push('latest')
              }
            }
          }
        }

        stage('Remove Unused docker image') {
          steps{
            sh "docker rmi $registry:$BUILD_NUMBER"
          }
        }
        
        stage('Deploy to k8s'){
        	agent { label 'Kube' }
            steps{
                script{
                	// sh "kubectl apply -f deploymentservice.yaml"
                	sh " kubectl set image deployment/$k8Deployment $k8Container=$registry:$BUILD_NUMBER"
                   // kubernetesDeploy (configs: 'deploymentservice.yaml',kubeconfigId: 'kubeconfic')
                }
            }
        }
    }
}
