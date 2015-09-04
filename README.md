# triton-syncthing-cluster

A Dockerized [Syncthing][1] Compose script for use on Joyent's Triton infrastructure. It uses Consul to share configuration and discover the IPs of other Syncthing devices.

[Syncthing][1] is let's you setup DIY Dropbox-like folders that stay in sync with each other. This can be useful for tasks that you might normally use `docker --volumes` for. Specific usage examples include backups, exporting configuration files, and syncing user uploads between servers. Basically this is ideal for situations where files are seldom written, and it's okay if changes take upto a minute to propagate to other containers. Also this works well for syncing content between web servers since reads are quick because the files are on local storage

For this to work you'll need to already have setup [Docker][2], [Docker-compose][3], and a Joyent [Triton][4] account.

```bash
# The simple way
bash start.sh
```

or 

```bash
# The detailed way

# Start up Consul and Syncthing
docker-compose --project-name=stc up -d --timeout=300

# Scale up more Syncthing containers
docker-compose --project-name=stc scale syncthing=4
```

This script is intended for Joyent Triton. It expects each Syncthing container to have its own unique IP address. These containers should be able to run on any Docker compatible infrastruture that gives each container an IP address to avoid exposed port collisions. View the [xer0x/triton-syncthing][5] image for more details.

[1]: https://syncthing.net/
[2]: http://docker.com
[3]: http://docs.docker.com/compose/
[4]: https://www.joyent.com/public-cloud
[5]: http://github.com/xer0x/triton-syncthing
