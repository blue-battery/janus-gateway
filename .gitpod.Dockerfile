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
    && apt-get install -y apt-fast \
#   12.4 MB
#    && aptitude update \
#    && aptitude safe-upgrade \
    && echo "alias apt-get='apt-fast'" >> ~/.bashrc \
    && echo "alias aptitude='apt-fast'" >> ~/.bashrc
#project rely
RUN apt-fast install -y libmicrohttpd-dev \
    libjansson-dev \
    libnice-dev \
    libssl-dev \
    libsrtp2-dev \
    libsofia-sip-ua-dev \
    libglib2.0-dev \
    libopus-dev \
    libogg-dev \
    pkg-config \
    gengetopt \
    libtool \
    automake

RUN apt-fast install -y vim cmake openssl libwebsockets-dev libconfig-dev libavutil-dev libavcodec-dev libavformat-dev
#    && apt-get clean && rm -rf /var/cache/apt/* && rm -rf /var/lib/apt/lists/* && rm -rf /tmp/*

RUN apt-fast install -y locales curl python3-distutils libusrsctp-dev nodejs npm nginx \
    && curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py \
    && python3 get-pip.py \
    && pip install -U pip \
#    && rm -rf /var/lib/apt/lists/* \
    && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
ENV LANG en_US.utf8
ADD requirements.txt ./
RUN pip install -r requirements.txt


COPY janus-gateway /janus-gateway
WORKDIR /janus-gateway
RUN sh autogen.sh &&  \
    PKG_CONFIG_PATH="$HOME/ffmpeg_build/lib/pkgconfig" ./configure \
    --enable-post-processing \
    --disable-boringssl \
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


