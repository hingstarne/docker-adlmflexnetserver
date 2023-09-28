FROM ubuntu:22.04
MAINTAINER hingst@tum.de

#########################################
##             CONSTANTS               ##
#########################################
# path for Network Licence Manager
ARG NLM_URL=https://download.autodesk.com/us/support/files/network_license_manager/linux/nlm11.18.0.0_ipv4_ipv6_linux64.tar.gz
# path for temporary files
ARG TEMP_PATH=/tmp/flexnetserver

#########################################
##        ENVIRONMENTAL CONFIG         ##
#########################################
# add the flexlm commands to $PATH
ENV PATH="${PATH}:/opt/flexnetserver/"

#########################################
##         RUN INSTALL SCRIPT          ##
#########################################
ADD /files /usr/local/bin

# Updating apt cache and installing necessary packages
RUN apt-get update -y && apt-get install -y \
    lsb-release \
    lsb-core \
    wget \
    fakeroot \
    alien && \
    apt-get clean && rm -rf /var/lib/apt/lists/* 

RUN mkdir -p ${TEMP_PATH} && cd ${TEMP_PATH} && \
    wget --progress=bar:force ${NLM_URL} && \
    tar -zxvf *.tar.gz && fakeroot alien -i *.rpm && \
    rm -rf ${TEMP_PATH}

# lmadmin is required for -2 -p flag support
RUN groupadd -r lmadmin && \
    useradd -r -g lmadmin lmadmin

#########################################
##              VOLUMES                ##
#########################################
VOLUME ["/var/flexlm"]

#########################################
##            EXPOSE PORTS             ##
#########################################
EXPOSE 2080
EXPOSE 27000-27009

# do not use ROOT user
USER lmadmin

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
# no CMD, use container as if 'lmgrd'
