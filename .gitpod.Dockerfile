FROM gitpod/workspace-full

USER gitpod

# Install custom tools, runtime, etc. using apt-get
# For example, the command below would install "bastet" - a command line tetris clone:
#
# RUN sudo apt-get -q update && #     sudo apt-get install -yq bastet && #     sudo rm -rf /var/lib/apt/lists/*
#
# More information: https://www.gitpod.io/docs/config-docker/
RUN sudo apt-get install -y libmicrohttpd-dev libjansson-dev libnice-dev \
libssl-dev libsrtp-dev libsofia-sip-ua-dev libglib2.0-dev \
libopus-dev libogg-dev pkg-config gengetopt libtool automake