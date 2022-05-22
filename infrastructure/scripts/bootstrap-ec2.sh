#!/usr/bin/env sh

# Update all packages that are currently in the selected AMI.
yum update -y

# Install docker. This command is recommended by AWS to install docker on EC2.
amazon-linux-extras install docker -y

# Start docker service.
service docker start

# Add user `ec2-user` to the docker group. This procedure is necessary to be able to run docker commands from a user other than `root`.
usermod -a -G docker ec2-user

# Configure docker so that docker service starts every time the instance is rebooted.
systemctl enable docker

# Install docker compose and give the appropriate permissions to the compose executable (https://docs.docker.com/compose/install/).
DOCKER_CONFIG=${DOCKER_CONFIG:-$HOME/.docker}
mkdir -p $DOCKER_CONFIG/cli-plugins
curl -SL https://github.com/docker/compose/releases/download/v2.5.0/docker-compose-linux-x86_64 -o $DOCKER_CONFIG/cli-plugins/docker-compose
chmod +x $DOCKER_CONFIG/cli-plugins/docker-compose
