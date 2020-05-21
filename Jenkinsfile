def CONTAINER_NAME="devops-tio-demo"
def CONTAINER_TAG="latest"
def DOCKER_HUB_USER="tjscott"
def HTTP_PORT="5000"
def TENABLE_ACCESS_KEY="e5c283e26ea113dd161a3f47df77ed9efde4fb5f9e259c73c330dfe560023f27"
def TENABLE_SECRET_KEY="4698f8602cf05b5df7a6de50caeaa53a13d8b1c2c2091638510163393018bdb5"

node {

    stage('Initialize'){
        def dockerHome = tool 'myDocker'
        env.PATH = "${dockerHome}/bin:${env.PATH}"
    }

    stage('Checkout') {
        checkout scm
    }

    stage("Image Prune"){
        imagePrune(CONTAINER_NAME)
    }

    stage('Image Build'){
        imageBuild(CONTAINER_NAME, CONTAINER_TAG)
    }

    stage('Tenable.IO Scan'){
        withCredentials([usernamePassword(credentialsId: 'tenableApiCredentials', usernameVariable: 'TENABLE_ACCESS_KEY', passwordVariable: 'TENABLE_SECRET_KEY')]){
            securityTest(CONTAINER_NAME,CONTAINER_TAG,DOCKER_HUB_USER,TENABLE_ACCESS_KEY,TENABLE_SECRET_KEY)
        }
    }

    stage('Push to Docker Registry'){
        withCredentials([usernamePassword(credentialsId: 'dockerHubCredentials', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
            pushToImage(CONTAINER_NAME, CONTAINER_TAG, USERNAME, PASSWORD)
        }
    }

    stage('Run App'){
        withCredentials([usernamePassword(credentialsId: 'tenableApiCredentials', usernameVariable: 'TENABLE_ACCESS_KEY', passwordVariable: 'TENABLE_SECRET_KEY')]){
            runApp(CONTAINER_NAME, CONTAINER_TAG, DOCKER_HUB_USER, HTTP_PORT, TENABLE_ACCESS_KEY, TENABLE_SECRET_KEY)
        }
    }

}

def imagePrune(containerName){
    try {
        sh "docker image prune -f"
        sh "docker stop $containerName"
    } catch(error){}
}

def imageBuild(containerName, tag){
    sh "docker build -t $containerName:$tag  -t $containerName ."
    echo "Image build complete"
}

def securityTest(containerName, tag, dockerHubUser, accessKey, secretKey){
    sh "docker login -u pubread -p BXaXRD9n3uEWKkGgt56eHVD5h tenableio-docker-consec-local.jfrog.io"
    sh "docker pull tenableio-docker-consec-local.jfrog.io/cs-scanner:latest"
    sh "docker save $containerName:$tag | docker run -e TENABLE_ACCESS_KEY=$accessKey -e TENABLE_SECRET_KEY=$secretKey -e IMPORT_REPO_NAME=$dockerHubUser -e CHECK_POLICY=1 -i tenableio-docker-consec-local.jfrog.io/cs-scanner:latest inspect-image $containerName:$tag"
    echo "Image Scan complete"
}

def pushToImage(containerName, tag, dockerUser, dockerPassword){
    sh "docker login -u $dockerUser -p $dockerPassword"
    sh "docker tag $containerName:$tag $dockerUser/$containerName:$tag"
    sh "docker push $dockerUser/$containerName:$tag"
    echo "Image push complete"
}

def runApp(containerName, tag, dockerHubUser, httpPort, accessKey,secretKey){
    //sh "docker pull $dockerHubUser/$containerName"
    try {
        sh "docker rm devops-tio-demo"
    } catch(error){}
    sh "docker run -d --rm -p $httpPort:$httpPort -e TENABLE_ACCESS_KEY=$accessKey -e TENABLE_SECRET_KEY=$secretKey --name $containerName $dockerHubUser/$containerName:$tag"
    echo "Application started on port: ${httpPort} (http)"
}