# Base Image
# Use LinuxServer.io Ubuntu:Bionic (18.04) base with s6
# but remove some of the branding

# many options, but probably 'bionic' and 'xenial' are of most interest
ARG UBUNTU_VERSION=bionic

FROM lsiobase/ubuntu:${UBUNTU_VERSION}

# these are provided by the build hook when run on Docker Hub
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

ARG UBUNTU_VERSION
ENV UBUNTU_VERSION=${UBUNTU_VERSION}

RUN \
    echo "**** generate en-CA locale ****" && \
    locale-gen en_CA.UTF-8

ENV LANGUAGE=en_CA.UTF-8 \
    LANG=en_CA.UTF-8

COPY root/ /

# having your PID 1 named "init" causes weird Docker bugs; renaming is one fix
# https://github.com/just-containers/s6-overlay/issues/158#issuecomment-266913426
RUN ln -s /init /s6-init
ENTRYPOINT [ "/s6-init" ]
