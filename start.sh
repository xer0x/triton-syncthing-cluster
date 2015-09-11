#!/bin/bash

# Run Docker compose to create containers.
#  - The `Docker up` results are 1 Syncthing and 1 Consul
#  - We wait for the containers to be running.
#  - We display the URL for the Syncthing Web UI
#  - We scale up 2 more Syncthings to our cluster

# Caution: this will automatically open a browser to view the Syncthing Web-UI


PREFIX=stc
export DOCKER_CLIENT_TIMEOUT=300

echo 'Starting Syncthing cluster'

echo
echo 'Pulling the most recent images'
docker-compose pull

echo
echo 'Starting containers'
docker-compose --project-name=$PREFIX up -d --no-recreate --timeout=300

echo
echo -n 'Initilizing cluster.'

sleep 1.3
SYNCTHINGRESPONSIVE=0
while [ $SYNCTHINGRESPONSIVE != 1 ]; do
    echo -n '.'

    RUNNING=$(docker inspect "$PREFIX"_syncthing_1 | json -a State.Running)
    if [ "$RUNNING" == "true" ]
    then
        let SYNCTHINGRESPONSIVE=1
    else
        sleep 1.3
    fi
done
echo

DASHBOARD_URL=$(docker exec -it stc_syncthing_1 bash -c 'source /consul_env.sh && echo $WEB_URL')
echo Dashboard url: $DASHBOARD_URL
command -v open >/dev/null 2>&1 && `open "$DASHBOARD_URL"`

echo
echo 'Scaling Syncthing cluster to three nodes'
echo "docker-compose --project-name=$PREFIX scale syncthing=3"
docker-compose --project-name=$PREFIX scale syncthing=3

echo
echo "Go ahead, try a lucky 7 node cluster:"
echo "docker-compose --project-name="$PREFIX" scale syncthing=7"

echo
echo "To clean up run:"
echo "docker-compose --project-name="$PREFIX" stop consul syncthing"
echo "docker-compose --project-name="$PREFIX" rm -f consul syncthing"

