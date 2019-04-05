# Base Image
# Use LinuxServer.io Ubuntu:Bionic (18.04) base with s6
# but remove some of the branding

FROM lsiobase/ubuntu:bionic

COPY ./root/ /
