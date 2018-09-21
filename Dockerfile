# Base image
# See https://github.com/phusion/baseimage-docker
FROM phusion/baseimage

LABEL author="Paulo A. Silva"
LABEL url="https://github.com/PauloASilva/TomTomSportsConnect"
LABEL description="Containerized TomTom Sports Connect"

RUN apt-get update && apt-get install wget

ENV PACKAGE="tomtomsportsconnect.x86_64.deb"
ENV URL="https://sports.tomtom-static.com/downloads/desktop/mysportsconnect/latest/$PACKAGE"

# Handle dependencies
RUN apt-get install -y \
    network-manager \
    libgstreamer0.10-0 \
    libgstreamer-plugins-base0.10-0 \
    libgl1-mesa-glx \
    "libxslt1.1" \
    "libsm6"

RUN curl -Lk -o /tmp/$PACKAGE $URL

RUN dpkg -i /tmp/$PACKAGE; exit 0

# Fix postinstall
## Disable udevadm
ENV POSTINST=/var/lib/dpkg/info/tomtomsportsconnect.postinst

RUN cp $POSTINST "$POSTINST.bak" && \
    head -n-2 "$POSTINST.bak" > "$POSTINST" && \
    rm "$POSTINST.bak" && \
    apt-get -f install
#

# inherit timezone from host system
# docker build needs to be executed with "--build-arg LOCALTIMEZONE=Region/City"
# e.g. "--build-arg LOCALTIMEZONE=Europe/Berlin" 
# if docker build is invoked with bundled script "build_dockerimage.sh", LOCALTIMEZONE will
# be get from host system
ARG LOCALTIMEZONE
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get install -f tzdata
RUN ln -fs /usr/share/zoneinfo/$LOCALTIMEZONE /etc/localtime && dpkg-reconfigure --frontend noninteractive tzdata


# Cleanup
RUN apt-get remove -y --purge wget && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    rm -r /tmp/*

ENV PATH="$PATH:/usr/local/TomTomSportsConnect/bin/"

CMD ["TomTomSportsConnect"]

