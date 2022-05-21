# syntax=docker/dockerfile:1
FROM node:lts@sha256:9b8eb61072127e898d8d2682f28508937fc21a853c6cb5587fa14d8b05ab4455 AS builder

# Install `node-prune` utility to remove reduntant files (e.g. `*.md`, `*.d.ts`) from `node_modules` and `dist` directory.
RUN apt-get install curl
RUN curl -sf https://gobinaries.com/tj/node-prune | sh

# Installing
#RUN yarn global add @nestjs/cli

# Set working directory inside docker container.
WORKDIR /usr/src/webhooks-receiver

# Copy files necessary to install dependencies.
COPY ./api/nest-cli.json /usr/src/webhooks-receiver/
COPY ./api/package.json /usr/src/webhooks-receiver/
COPY ./api/src/ /usr/src/webhooks-receiver/src/
COPY ./api/tsconfig.build.json /usr/src/webhooks-receiver/
COPY ./api/tsconfig.json /usr/src/webhooks-receiver/
COPY ./api/yarn.lock /usr/src/webhooks-receiver/

# In this step, I install all the dependencies needed to build the project. I must remember to install dev dependencies such as TypeScript, because they are used to build the project.
RUN yarn install --frozen-lockfile --silent

# In this step, I execute the command that is responsible for building the production version of the project.
RUN yarn build

# Here I remove all currently installed dependencies, because in the production image I don't need to include dependencies used at development time (e.g. TypeScript, webpack).
RUN rm -rf node_modules

# Finally, I only install the production dependencies that are necessary to run my application.
RUN yarn --frozen-lockfile --production --silent

# Prun all unnecessary files.
RUN node-prune

FROM node:lts-alpine@sha256:bb776153f81d6e931211e3cadd7eef92c811e7086993b685d1f40242d486b9bb AS production

# Declaring all instructions that install dependencies used in the docker container right below the image declaration is a good practice because it allows you to take advantage of docker layer caching.
# Install tool for acting like init process (which runs with PID=1) and proxying signal to the node process itself.
RUN apk add dumb-init

# I need to copy the source files and production dependencies to the new image build stage.
COPY --chown=node:node --from=builder /usr/src/webhooks-receiver/node_modules/ /usr/src/webhooks-receiver/node_modules
COPY --chown=node:node --from=builder /usr/src/webhooks-receiver/dist/ /usr/src/webhooks-receiver/

RUN chown -R node:node /usr/src/webhooks-receiver/

# Configure the user who will own the running process.
# By default, all the node docker images ship with the `node` user to implement `the least-privilage` principle.
USER node

# Set working directory inside docker container.
WORKDIR /usr/src/webhooks-receiver

# By using the `execform` notation in CMD instruction, I can ensure that signals sent to the container are directly sent to the process.
CMD ["dumb-init", "node", "main.js"]
