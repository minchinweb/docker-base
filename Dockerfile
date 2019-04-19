# Base Image
# Use LinuxServer.io Ubuntu:Bionic (18.04) base with s6
# but remove some of the branding

# many options, but probably 'bionic' and 'xenial' are of most interest
ARG UBUNTU_VERSION=bionic

FROM lsiobase/ubuntu:${UBUNTU_VERSION}

LABEL maintainer="MinchinWeb"

RUN \
    echo "**** generate en-CA locale ****" && \
    locale-gen en_CA.UTF-8

COPY root/ /
