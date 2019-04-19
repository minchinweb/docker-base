# Base Image
# Use LinuxServer.io Ubuntu:Bionic (18.04) base with s6
# but remove some of the branding

# many options, but probably 'bionic' and 'xenial' are of most interest
ARG UBUNTU_VERSION=bionic

FROM lsiobase/ubuntu:${UBUNTU_VERSION}

ARG BUILD_DATE="1970-01-01T00:00:00Z"
ARG COMMIT="local-build"
ARG URL=""
ARG BRANCH="none"

LABEL maintainer="MinchinWeb" \
      org.label-schema.description="Personal base image, based on Ubuntu" \
      org.label-schema.build-date=${BUILD_DATE} \
      org.label-schema.vcs-url=${URL} \
      org.label-schema.vcs-ref=${COMMIT} \
      org.label-schema.schema-version="1.0.0-rc1"

ENV COMMIT_SHA=${COMMIT} \
    COMMIT_BRANCH=${BRANCH} \
    BUILD_DATE=${BUILD_DATE}

RUN \
    echo "**** generate en-CA locale ****" && \
    locale-gen en_CA.UTF-8

COPY root/ /
