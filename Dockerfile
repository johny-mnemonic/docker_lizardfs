FROM resin/rpi-raspbian:buster

# Install wget and busybox ( for vi )
RUN apt-get update && \
    apt-get install -y busybox gettext-base wget && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Alias to busybox for vi
RUN echo 'alias vi="busybox vi"' >> /root/.bashrc

# Add staging apt repository to get latest LizardFS packages
RUN echo "deb http://archive.raspbian.org/raspbian buster-staging main" > /etc/apt/sources.list.d/lizardfs.list 

# Install LizardFS packages
RUN apt-get update && \
    apt-get install -y \
      lizardfs-master \
      lizardfs-metalogger \
      lizardfs-chunkserver \
      lizardfs-cgiserv \
      lizardfs-adm \
      lizardfs-client && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Ensure the `lizardfs` user and group has a consistent uid/gid
RUN usermod -u 9421 lizardfs
RUN groupmod -g 9421 lizardfs

#### LIZARDFS MASTER CONFIG ####

# Copy empty metadata file to a spot that will not be overwritten by a volume
RUN cp /var/lib/lizardfs/metadata.mfs.empty /metadata.mfs.empty

# Setup mfsmaster.cfg
## Default to a master
ENV MFSMASTER_PERSONALITY=master

# Setup mfsexports.cfg defaults
## Allow everything but "meta".
ENV MFSEXPORTS_1="*                       /       rw,alldirs,maproot=0"
## Allow "meta".
ENV MFSEXPORTS_2="*                       .       rw"

# Setup mfsgoals.cfg defaults
ENV MFSGOALS_1="1 1 : _"
ENV MFSGOALS_2="2 2 : _ _"
ENV MFSGOALS_3="3 3 : _ _ _"
ENV MFSGOALS_4="4 4 : _ _ _ _"
ENV MFSGOALS_5="5 5 : _ _ _ _ _"

#### LIZARDFS METALOGGER CONFIG ####
RUN echo "# LizardFS Metalogger config" >> /etc/lizardfs/mfsmetalogger.cfg

#### LIZARDFS CHUNKSERVER CONFIG ####
RUN echo "# LizardFS Chunkserver config" >> /etc/lizardfs/mfschunkserver.cfg

# Copy in configuration script
COPY configure.sh /configure.sh
RUN chmod 744 /configure.sh

# Copy in command script
COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod 744 /docker-entrypoint.sh

# Expose Ports
EXPOSE 9419 9420 9421 9424

# Set the Docker entrypoint and default command
ENTRYPOINT [ "/docker-entrypoint.sh" ]
CMD [ "master" ]

