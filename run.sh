#!/bin/sh


echo "executing docker run"
docker run -d -p 5000:5000 -e TENABLE_ACCESS_KEY=e5c283e26ea113dd161a3f47df77ed9efde4fb5f9e259c73c330dfe560023f27 -e TENABLE_SECRET_KEY=4698f8602cf05b5df7a6de50caeaa53a13d8b1c2c2091638510163393018bdb5 --name devops-tio-demo devops-tio-demo