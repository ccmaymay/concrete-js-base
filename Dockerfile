# Dockerfile for ccmaymay/concrete-js-base on Docker Hub

FROM node:16

# OPTIONAL: Install dumb-init (Very handy for easier signal handling of SIGINT/SIGTERM/SIGKILL etc.)
RUN wget https://github.com/Yelp/dumb-init/releases/download/v1.2.0/dumb-init_1.2.0_amd64.deb
RUN dpkg -i dumb-init_*.deb
ENTRYPOINT ["dumb-init"]

# Install Google Chrome
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -
RUN wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
RUN apt-get update && apt install -y ./google-chrome-stable_current_amd64.deb

RUN apt-get install -y bison flex libboost-dev

# Install Thrift with patched js server code generation
RUN git clone -b v0.19.0 https://github.com/apache/thrift.git /opt/thrift
WORKDIR /opt/thrift
RUN ./bootstrap.sh && \
    ./configure --without-c_glib --without-cpp --without-python --without-py3 && \
    make && \
    make install
