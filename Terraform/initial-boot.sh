#! /bin/bash
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo docker pull sachinshrma/petclinic:1.0.0
sudo docker run -d --name webapp sachinshrma/petclinic:1.0.0