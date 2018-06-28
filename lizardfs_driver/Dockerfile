#FROM arm32v7/node:8.11.3-stretch
#FROM resin/rpi-node:8.11.2-onbuild-20180617
FROM resin/rpi-node:8.11.2-slim-20180617

# Add staging apt repository to get latest LizardFS packages
#RUN wget https://archive.raspbian.org/raspbian.public.key -O - | apt-key add -

RUN echo "deb http://archive.raspbian.org/raspbian buster-staging main" > /etc/apt/sources.list.d/lizardfs.list

RUN apt-get update && \
    apt-get install -y lizardfs-client && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir -p /mnt/lizardfs

RUN mkdir -p /mnt/docker-volumes

COPY project/package* /project/

WORKDIR /project

RUN npm install

ENV HOST=mfsmaster PORT=9421 ALIAS=lizardfs ROOT_VOLUME_NAME= MOUNT_OPTIONS= REMOTE_PATH=/docker/volumes LOCAL_PATH= CONNECT_TIMEOUT=10000 LOG_LEVEL=info

COPY project/index.js /project/index.js

ENTRYPOINT [ "node", "index.js" ]
