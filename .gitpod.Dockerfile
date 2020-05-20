FROM gitpod/workspace-full

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
    libconfig-dev \
    gengetopt \
    libtool \
    automake
#    && apt-get clean && rm -rf /var/cache/apt/* && rm -rf /var/lib/apt/lists/* && rm -rf /tmp/*

COPY janus-gateway /janus-gateway
WORKDIR /janus-gateway