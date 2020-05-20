#!/bin/sh

echo "Deploy script started"
app="psko-devops-demo"
if docker ps | awk -v app="$app" 'NR > 1 && $NF == app{ret=1; exit} END{exit !ret}'; then
  echo "Found running image,  removing it"
  docker stop "$app" && docker rm -fv "$app"
fi
echo "executing docker pull latest image"
docker login -u 41185fd1b69ecdcca09bf1f177b1f22767812b3b744466a8e0c932c9a6cee79d -p 5cd3d3f7cff0dc6801b7bd7c11ecffe5a4ba96e1e8f92ed1da4b3192b31353c5 registry.cloud.tenable.com
docker pull tjscott/psko-devops-demo
echo "executing docker run"
docker run -d -p 5000:5000 --name psko-devops-demo tjscott/psko-devops-demo