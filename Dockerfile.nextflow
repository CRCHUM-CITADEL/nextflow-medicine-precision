FROM rockylinux/rockylinux:8.10

# install java 17 as prerequisite
RUN dnf -y update && dnf install -y \
    curl wget java-17-openjdk \
    && dnf clean all

#set version of nextflow
ENV NXT_VER=25.04.6

# install nextflow (based on version above) and check version
RUN curl -s https://get.nextflow.io | bash \
    && mv nextflow /usr/local/bin/nextflow \
    && nextflow -v

# ADD ANY MORE SOFTWARE WE MIGHT NEED HERE ()
#
#
#

WORKDIR /app

