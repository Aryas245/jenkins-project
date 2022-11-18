pipeline {
    agent any
	tools {
		maven 'Maven'
	}
	
	environment {
		PROJECT_ID = 'i-monolith-366616'
        CLUSTER_NAME = 'cluster-1'
        LOCATION = 'us-east1-c'
        CREDENTIALS_ID = 'kubernetes'		
	}
	
    stages {
	    stage('SCM Checkout') {
		    steps {
			    checkout scm
		    }
	    }

           stage('Build') {
		    steps {
			    sh 'mvn clean package'
		    }
	    }
	    
	    stage('Test') {
		    steps {
			    echo "Testing..."
			    sh 'mvn test'
		    }
	    }
	    
	     stage('Build Docker Image') {
		    steps {
			    sh 'whoami'
			    script {
				    myimage = docker.build("aryas13/jenkins_project:${env.BUILD_ID}")
			    }
		    }
	    }
	    
	    stage("Push Docker Image") {
		    steps {
			    script {
				    echo "Push Docker Image"
				    withCredentials([string(credentialsId: 'dockerhub', variable: 'dockerhub')]) {
            				sh "docker login -u aryas13 -p ${dockerhub}"
				    }
				        myimage.push("${env.BUILD_ID}")
				    
			    }
		    }
	    }
	    
	    stage('Deploy to K8S') {
		    steps{
			    echo "Deployment started ..."
			    sh 'ls -ltr'
			    sh 'pwd'
			    sh "sed -i 's/tagversion/${env.BUILD_ID}/g' springBootMongo.yml"
				sh "sed -i 's/tagversion/${env.BUILD_ID}/g' serviceLB.yaml"
			    echo "Start deployment of springBootMongo.yml"
			    step([$class: 'KubernetesEngineBuilder', projectId: env.PROJECT_ID, clusterName: env.CLUSTER_NAME, location: env.LOCATION, manifestPattern: 'springBootMongo.yml', credentialsId: env.CREDENTIALS_ID, verifyDeployments: true])
				/**echo "Start deployment of deployment.yaml"**/
				step([$class: 'KubernetesEngineBuilder', projectId: env.PROJECT_ID, clusterName: env.CLUSTER_NAME, location: env.LOCATION, manifestPattern: 'serviceLB.yaml', credentialsId: env.CREDENTIALS_ID, verifyDeployments: true])
			    echo "Deployment Finished ..."
		    }
	    }
    }
}
