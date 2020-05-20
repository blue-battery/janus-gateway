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
# this will take a bit time
RUN set -x \
    && apt-get update

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

RUN apt-get install -y libmicrohttpd-dev \
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
    automake \
    && apt-get clean && rm -rf /var/cache/apt/* && rm -rf /var/lib/apt/lists/* && rm -rf /tmp/*


#COPY janus-gateway /janus-gateway
#WORKDIR /janus-gateway
#RUN ls && pwd

#CMD ["node","server.js"]
#sudo systemctl restart docker

