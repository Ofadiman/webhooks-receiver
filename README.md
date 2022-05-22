# Webhooks Receiver

Mini project that allows you to run a server that will receive webhooks.

# Docker on EC2

When the AMI image is launched, the EC2 instance will not have docker installed by default. There are several ways to get docker running on EC2:

1. Manually installing docker and docker compose after connecting to the EC2 instance via SSH.
2. Automatically installing docker and docker compose when the EC2 instance boots up for the first time via `userdata`.
3. Creating custom AMI that will have docker and docker compose installed and running the instance through the created AMI.

In this project I first used the first option to test everything manually.
Once I had a working EC2 instance that was able to download and run docker images I wrote a script which I then placed in `userdata`.

# Things to automate in the future

- Creating a new version of docker image.
- Deploying a new version of an image using docker compose.
- Pulling docker images from ECR.

# Resources

- [10 best practices to containerize Node.js application.](https://snyk.io/blog/10-best-practices-to-containerize-nodejs-web-applications-with-docker/)
- [Article explaining why I should always set `NODE_ENV` variable to `production`.](https://www.dynatrace.com/news/blog/the-drastic-effects-of-omitting-node-env-in-your-express-js-applications/)
- [Best practices for building docker images from Node.js docker working group.](https://github.com/nodejs/docker-node/blob/main/docs/BestPractices.md#handling-kernel-signals)
- [How to use docker on AWS EC2.](https://betterprogramming.pub/how-to-use-docker-in-an-amazon-ec2-instance-5453601ec330)
- [Official docker documentation about installing docker compose on linux operating system.](https://docs.docker.com/compose/install/)
