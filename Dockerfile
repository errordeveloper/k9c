#FROM node:9.4.0-alpine AS build
FROM node:4-alpine AS build

RUN apk add --update bash git make gcc g++ python curl tmux tar

RUN mkdir -p /src/c9
RUN curl --silent 'https://codeload.github.com/c9/core/tar.gz/cfedceb' \
  | tar --extract --gunzip --directory /src/c9 ; \
  ln -s /src/c9/core-cfedceb /src/c9/core
WORKDIR /src/c9/core

RUN npm install --production
RUN npm install pty.js sqlite3@3.1.8 sequelize@2.0.0-beta.0 https://github.com/c9/nak/tarball/c9
RUN mkdir -p /root/.c9 ; cd /root/.c9 ; \
  mkdir -p bin ; ln -s /usr/bin/tmux bin/tmux ; \
  mkdir -p node/bin ; ln -s /usr/bin/node node/bin/node ; \
  mkdir -p node/bin ; ln -s /usr/bin/npm node/bin/npm ; \
  ln -s /src/c9/core/node_modules node_modules ; \
  echo 1 > installed
ENTRYPOINT [ "node", "server.js", "--listen", "0.0.0.0", "--port", "8080", "--auth", "username:password" ]
