#!/bin/bash

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

# TODO: extract Syncthing UI user/password from Consul
# TODO: open web page

#echo
#echo 'Syncthing cluster running and bootstrapped'
#echo "Dashboard: $DASHBOARD_URL"
#echo "username=USERNAME"
#echo "password=PASSWORD"
#command -v open >/dev/null 2>&1 && `open http://$DASHBOARD_URL/`

echo
echo 'Scaling Syncthing cluster to three nodes'
echo "docker-compose --project-name=$PREFIX scale syncthing=3"
docker-compose --project-name=$PREFIX scale syncthing=3

echo
echo "Go ahead, try a lucky 7 node cluster:"
echo "docker-compose --project-name="$PREFIX" scale syncthing=7"
