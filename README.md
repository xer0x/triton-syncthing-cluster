# triton-syncthing-cluster

A Dockerized [Syncthing][1] container for use on Joyent's Triton infrastructure. It uses Consul to share configuration and discover the IPs of other Syncthing devices.

[Syncthing][1] is let's you setup DIY Dropbox-like folders that stay in sync with each other.

For this to work you'll need to already have setup [Docker][2], [Docker-compose][3], and a Joyent [Triton][4] account.

```bash
bash start.sh
```

or 

```bash
# Start up Consul and Syncthing
docker-compose --project-name=stc up -d --timeout=300

# Scale up more Syncthing containers
docker-compose --project-name=stc scale syncthing=4
```

[1]: https://syncthing.net/
[2]: http://docker.com
[3]: http://docs.docker.com/compose/
[4]: https://www.joyent.com/public-cloud
