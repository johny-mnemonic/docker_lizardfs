FROM docker:18.05

ENV CONTAINER_NAME= FORCE_UPDATE=true

COPY docker-entrypoint.sh /docker-entrypoint.sh

RUN chmod 744 /docker-entrypoint.sh 

ENTRYPOINT [ "sh", "docker-entrypoint.sh" ]
