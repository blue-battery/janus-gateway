#FROM gitpod/workspace-full
#
#USER gitpod


#FROM ubuntu
#
#RUN apt-get update && \
#    apt-get install
#
#CMD [ "node", "server.js" ]

FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

USER root

RUN sed -i 's/archive.ubuntu.com/mirror.aarnet.edu.au\/pub\/ubuntu\/archive/g' /etc/apt/sources.list

# this will take a bit time
RUN set -x \
    && apt-get update
# base software
RUN set -x \
    #35.6Mb to 154Mb
    && apt-get install -y software-properties-common \
    && add-apt-repository ppa:apt-fast/stable \
    && apt-get install -y apt-utils apt-fast \
#   12.4 MB
#    && aptitude update \
#    && aptitude safe-upgrade \
    && echo "alias apt-get='apt-fast'" >> ~/.bashrc \
    && echo "alias aptitude='apt-fast'" >> ~/.bashrc
#project rely
#RUN rm -rf /var/lib/apt/lists/*
RUN set -x && \
    apt-fast -y update && apt-fast install -y libmicrohttpd-dev \
    libjansson-dev \
    libnice-dev \
    libssl-dev \
    libsrtp2-dev \
    libsofia-sip-ua-dev \
    libglib2.0-dev \
    libopus-dev \
    libogg-dev \
    libini-config-dev \
    libcollection-dev \
    libconfig-dev \
    pkg-config \
    gengetopt \
    libtool \
    automake \
    build-essential \
    subversion \
    git \
    cmake \
    unzip \
    zip \
    lsof wget vim sudo rsync cron mysql-client openssh-server supervisor locate gstreamer1.0-tools mplayer valgrind certbot python3-certbot-apache dnsutils

RUN set -x && \
    apt-fast install -y  openssl libwebsockets-dev libconfig-dev libavutil-dev libavcodec-dev libavformat-dev
#    && apt-get clean && rm -rf /var/cache/apt/* && rm -rf /var/lib/apt/lists/* && rm -rf /tmp/*

RUN set -x && \
    apt-fast install -y locales curl python3-distutils libusrsctp-dev nodejs npm nginx \
    && curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py \
    && python3 get-pip.py \
    && pip install -U pip \
#    && rm -rf /var/lib/apt/lists/* \
    && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
ENV LANG en_US.utf8
ADD requirements.txt ./
RUN pip install -r requirements.txt


# Boringssl build section
# If you want to use the openssl instead of boringssl
# RUN apt-get update -y && apt-get install -y libssl-dev
RUN set -x && apt-fast -y update && apt-fast install -y --no-install-recommends \
        g++ \
        gcc \
        libc6-dev \
        make golang-1.7.5-go
#        curl \
#        pkg-config \
#    && rm -rf /var/lib/apt/lists/*
ENV GOLANG_VERSION 1.7.5
ENV GOLANG_DOWNLOAD_URL https://storage.googleapis.com/golang/go$GOLANG_VERSION.linux-amd64.tar.gz
ENV GOLANG_DOWNLOAD_SHA256 2e4dd6c44f0693bef4e7b46cc701513d74c3cc44f2419bf519d7868b12931ac3
RUN curl -fsSL "$GOLANG_DOWNLOAD_URL" -o golang.tar.gz \
    && echo "$GOLANG_DOWNLOAD_SHA256  golang.tar.gz" | sha256sum -c - \
    && tar -C /usr/local -xzf golang.tar.gz \
    && rm golang.tar.gz

ENV GOPATH /go
ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH
RUN mkdir -p "$GOPATH/src" "$GOPATH/bin" && chmod -R 777 "$GOPATH"
# https://boringssl.googlesource.com/boringssl/+/chromium-stable
RUN git clone https://boringssl.googlesource.com/boringssl && \
    cd boringssl && \
    git reset --hard c7db3232c397aa3feb1d474d63a1c4dd674b6349 && \
    sed -i s/" -Werror"//g CMakeLists.txt && \
    mkdir -p build  && \
    cd build  && \
    cmake -DCMAKE_CXX_FLAGS="-lrt" ..  && \
    make  && \
    cd ..  && \
    sudo mkdir -p /opt/boringssl  && \
    sudo cp -R include /opt/boringssl/  && \
    sudo mkdir -p /opt/boringssl/lib  && \
    sudo cp build/ssl/libssl.a /opt/boringssl/lib/  && \
    sudo cp build/crypto/libcrypto.a /opt/boringssl/lib/

COPY janus-gateway /janus-gateway
WORKDIR /janus-gateway
RUN sh autogen.sh &&  \
    PKG_CONFIG_PATH="$HOME/ffmpeg_build/lib/pkgconfig" ./configure \
    --enable-post-processing \
    --enable-boringssl \
    --enable-data-channels \
    --disable-rabbitmq \
    --disable-mqtt \
    --disable-unix-sockets \
    --enable-dtls-settimeout \
    --enable-plugin-echotest \
    --enable-plugin-recordplay \
    --enable-plugin-sip \
    --enable-plugin-videocall \
    --enable-plugin-voicemail \
    --enable-plugin-textroom \
    --enable-plugin-audiobridge \
    --enable-plugin-nosip \
    --enable-all-handlers && \
    make && make install && make configs && ldconfig

COPY nginx.conf /usr/local/nginx/nginx.conf


ENV NVM_VERSION v0.35.3
ENV NODE_VERSION v10.16.0
ENV NVM_DIR /usr/local/nvm
RUN mkdir $NVM_DIR
RUN curl -o- https://raw.githubusercontent.com/creationix/nvm/$NVM_VERSION/install.sh | bash

ENV NODE_PATH $NVM_DIR/v$NODE_VERSION/lib/node_modules
ENV PATH $NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH

RUN echo "source $NVM_DIR/nvm.sh && \
    nvm install $NODE_VERSION && \
    nvm alias default $NODE_VERSION && \
    nvm use default" | bash


SHELL ["/bin/bash", "-l", "-euxo", "pipefail", "-c"]
RUN node -v
RUN npm -v


CMD nginx && janus



