pipeline {
    agent any
    options {
        disableConcurrentBuilds()
    }
    environment {
        DOCKER_REPO = "docker.dev.pureport.com"
        DEB_BUILDER_IMAGE = "pureport/deb-builder"
        UID = getUid()
        GID = getGid()
    }
    stages {
        stage('Build') {
            when {
                branch "pureport/*"
            }
            steps {
                script {
                    def workspace = pwd()
                    sh "git fetch --tags"
                    sh "docker run --rm -v ${workspace}:/src -v ${workspace}:/output -e USER=${env.UID} -e GROUP=${env.GID} ${env.DOCKER_REPO}/${env.DEB_BUILDER_IMAGE} /src/build-debs.sh"
                }
            }
        }
        stage('Add to Aptly repo') {
            when {
                branch "pureport/stable/*"
            }
            steps {
                script {
                    echo "Add to Aptly repo..."
                    sh "aptly repo add frr ."
                }
            }
        }
    }
    post {
        always {
            /* clean up our workspace */
            deleteDir()
        }
        success {
            slackSend(color: '#30A452', message: "SUCCESS: <${env.BUILD_URL}|${env.JOB_NAME}#${env.BUILD_NUMBER}>")
        }
        unstable {
            slackSend(color: '#DD9F3D', message: "UNSTABLE: <${env.BUILD_URL}|${env.JOB_NAME}#${env.BUILD_NUMBER}>")
        }
        failure {
            slackSend(color: '#D41519', message: "FAILED: <${env.BUILD_URL}|${env.JOB_NAME}#${env.BUILD_NUMBER}>")
        }
    }
}

def getUid() {
    sh(returnStdout: true, script: "id -u").trim()
}

def getGid() {
    sh(returnStdout: true, script: "id -g").trim()
}
