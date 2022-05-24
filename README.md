# Webhooks Receiver

Mini project that allows you to run a server that will receive webhooks.

# Docker on EC2

When the AMI image is launched, the EC2 instance will not have docker installed by default. There are several ways to get docker running on EC2:

1. Manually installing docker and docker compose after connecting to the EC2 instance via SSH.
2. Automatically installing docker and docker compose when the EC2 instance boots up for the first time via `userdata`.
3. Creating custom AMI that will have docker and docker compose installed and running the instance through the created AMI.

In this project I first used the first option to test everything manually.
Once I had a working EC2 instance that was able to download and run docker images I wrote a script which I then placed in `userdata`.

# TLS

1. I first installed certbot using [this tutorial](https://www.inmotionhosting.com/support/website/ssl/lets-encrypt-ssl-ubuntu-with-certbot/). I used the option to install certbot via python3 because EC2 instances already have python3 installed by default.
2. I then generated a TLS certificate using the `sudo certbot certonly --manual` command.
3. I then updated the docker configuration to mount the generated certificates under path I choose in the container.
4. Finally, I updated the server configuration so that TLS encryption was used during the connection establishment.

# Problems with TLS certificates

Real TLS certificates do not live in the `live` folder, but in the `archive` folder. Files present in the `live` folder are links to files in the `archive` folder. To be able to read the certificate files in the Node.js application, I had to mount the entire `letsencrypt` folder to the docker container running the application. I found the solution to the problem in [this post](https://stackoverflow.com/questions/60563144/accessing-ssl-pem-files-inside-docker-container).

In order to be able to mount the `/etc/letsencrypt` folder I had to change the user that owns it from `root` to `ec2-user`. I did this using the `sudo chown -R ec2-user:ec2-user /etc/letsencrypt` command.

# Resources

- [10 best practices to containerize Node.js application.](https://snyk.io/blog/10-best-practices-to-containerize-nodejs-web-applications-with-docker/)
- [Article explaining why I should always set `NODE_ENV` variable to `production`.](https://www.dynatrace.com/news/blog/the-drastic-effects-of-omitting-node-env-in-your-express-js-applications/)
- [Best practices for building docker images from Node.js docker working group.](https://github.com/nodejs/docker-node/blob/main/docs/BestPractices.md#handling-kernel-signals)
- [How to use docker on AWS EC2.](https://betterprogramming.pub/how-to-use-docker-in-an-amazon-ec2-instance-5453601ec330)
- [Official docker documentation about installing docker compose on linux operating system.](https://docs.docker.com/compose/install/)
