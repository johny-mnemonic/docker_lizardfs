#!/bin/bash

####
# Start container
####

log_prefix='[docker-run-d]'

echo "$log_prefix Starting up"

# If the container name has been set
if [ -n "$CONTAINER_NAME" ]; then

    # If FORCE_UPDATE is true
    if [ "$FORCE_UPDATE" = "true" ]; then

        # Stop and remove the container ( in case it already exists )
        echo "$log_prefix FORCE_UPDATE is true: removing container '$CONTAINER_NAME' if it exists"
        docker stop $CONTAINER_NAME
        docker rm $CONTAINER_NAME
    fi

    # Start the container ( in case it is not already running )
    echo "$log_prefix Starting container: '$CONTAINER_NAME'"
    eval "docker run -d --name $CONTAINER_NAME $1"

    # Follow the container logs
    echo "$log_prefix Starting container logs:"
    docker logs -f $CONTAINER_NAME &

    # Trap the kill signal
    trap 'echo "$log_prefix Got kill signal: Stopping and removing container"; docker stop $CONTAINER_NAME; docker rm $CONTAINER_NAME; exit 0' SIGTERM SIGINT
else

    # Run the container without specifying a name and record the container id
    echo "$log_prefix Starting container"
    eval "docker run -d $1 > /container_id"

    # Follow the container logs
    echo "$log_prefix Starting container logs:"
    docker logs -f $(cat /container_id) &

    # Trap the kill signal
    trap 'echo "$log_prefix Got kill signal: Stopping and removing container"; docker stop $(cat /container_id); docker rm $(cat /container_id); exit 0' SIGTERM SIGINT
fi


# Wait for signal
while true; do sleep 1; done