# latest is node:9.4.0-alpine, but c9 seems to depend on 4.4, so we get some 4.x version to stay on the safe side
FROM node:4-alpine AS build

RUN apk add --update \
    bash \
    curl \
    g++ \
    gcc \
    git \
    make \
    py-pip \
    python \
    python-dev \
    tmux \
    && true

RUN mkdir /out
RUN mkdir -p /out/usr/local && cp -r /usr/local/* /out/usr/local/
RUN mkdir -p /out/etc/apk && cp -r /etc/apk/* /out/etc/apk/
RUN apk add --no-cache --initdb --root /out \
    alpine-baselayout \
    bash \
    busybox \
    ca-certificates \
    coreutils \
    curl \
    git \
    jq \
    libc6-compat \
    libgcc \
    libstdc++ \
    make \
    openssh-client \
    python \
    tmux \
    vim \
    && true

RUN mkdir -p /out/src/c9
WORKDIR /out/src/c9
RUN curl --silent 'https://codeload.github.com/c9/core/tar.gz/cfedceb' \
    | tar xz && ln -s core-cfedceb core

WORKDIR /out/src/c9/core
RUN npm install --production
RUN npm install pty.js sqlite3@3.1.8 sequelize@2.0.0-beta.0 https://github.com/c9/nak/tarball/c9

RUN mkdir -p /out/root/.c9 ; cd /out/root/.c9 ; \
    mkdir -p bin ; ln -s /usr/bin/tmux bin/tmux ; \
    mkdir -p node/bin ; ln -s /usr/local/bin/node node/bin/node ; \
    mkdir -p node/bin ; ln -s /usr/local/bin/npm node/bin/npm ; \
    ln -s ../../src/c9/core/node_modules node_modules ; \
    echo 1 > installed

RUN rm -rf /out/etc/apk /out/lib/apk /out/var/cache

WORKDIR /out

RUN ln -s /lib /lib64

ENV KUBECTL_VERSION v1.9.1
RUN curl --silent --location "https://dl.k8s.io/${KUBECTL_VERSION}/bin/linux/amd64/kubectl" --output usr/local/bin/kubectl \
    && chmod +x usr/local/bin/kubectl

ENV DOCKER_VERSION 18.03.0
RUN curl --silent --location "https://download.docker.com/linux/static/stable/x86_64/docker-${DOCKER_VERSION}-ce.tgz" \
    | tar xz docker/docker && mv docker/docker usr/local/bin/docker && rm -rf docker

ENV GCLOUD_VERSION 196.0.0
RUN curl --silent --location "https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-${GCLOUD_VERSION}-linux-x86_64.tar.gz" \
    | tar xz \
    && pip install --root=/out crcmod==1.7

RUN mkdir -p /out/workspace

COPY in-cluster-config.yaml /out/etc/
COPY gcloud-git.sh /out/etc/profile.d/
COPY clone-repos.sh /out/usr/local/bin

FROM stefanprodan/loadtest as loadtest

FROM scratch

WORKDIR /workspace
ENV KUBECONFIG /etc/in-cluster-config.yaml
ENTRYPOINT [ "node", "/src/c9/core/server.js", "--listen", "0.0.0.0", "--port", "8080", "-w", "/workspace" ]
COPY --from=build  /out /
COPY --from=loadtest /go/bin/hey /usr/local/bin/hey
