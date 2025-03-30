# The Lord of the Rings: Return to Moria Dedicated Server

## The What
Ubuntu based Docker image recipe for a [Return to Moria](https://www.returntomoria.com/) dedicated server.

## The How
Server binaries are made available for free directly from Steam and installed using `steamcmd`. Only Windows binaries are available, so the game server is run using `wine`. The server opens a dedicated console window for server management, which is captured in virtual framebuffer (`Xvfb`) and connection to it is done using a VNC server/client (`x11vnc/vncviewer`).

An initial world, `Brave New World`, is provided by default, and the password to the world is `bravenewworld`; more details [below](#startup-world).

## Ports
- 7777/udp (Game)
- 5900 (VNC, optional but strongly recommended)
- 22 (SSH, if enabled; optional)

## Volumes
- /server: Recommended to mount a volume to this path to keep the server data persistent and to avoid downloading the server files every time the container is started.

## Building the image
```
docker build -t {image-name}:{image-tag} .
```

## Running the container
```
docker run -d --name {container-name} -p 7777:7777/udp -p 5900:5900 -v {host-path}:/server {image-name}:{image-tag}
```

## Additional details
### Connecting to the server console
From somewhere where 5900 port is accessible, install  and run `vncviewer`: 
```
vncviewer :0
```
On Ubuntu, this is part of the `xtightvncviewer` package. X server must be running where this is invoked.

### Startup world
The image provides an initial world. This can be changed by adjusting `Copying world files...` section in the [entrypoint.sh](entrypoint.sh). The default world is `Brave New World` and the password to the world is `bravenewworld`. This can be changed under `OptionalPassword=` option in the `MoriaServerSettings.ini` file:
* [here](config/MoriaServerConfig.ini) prior to building the image;
* in `/server/Moria/MoriaServerConfig.ini` after the server has been started.

If no world is provided, on first run, the server will create one, but connections to it will not be possible until the container is restarted. `VNC` connection is strongly recommended to see what the server console.

### SSH 
If SSH-ing into the container is desired, prior to building the image:
* uncomment `/usr/sbin/sshd &` in the [entrypoint.sh](entrypoint.sh) file;
* generate a key pair;
* adjust `COPY moria.pub /root/.ssh/authorized_keys` in the [Dockerfile](Dockerfile) to copy the public key to the container.

Then, connect using ssh and the corresponding key. Do not forget to expose port 22 when running the container.

## Disclaimer
I am in no way affiliated with the developers and/or publishers of the game. This is a personal but fun project which might benefit someone else. Be sure to check the [official dedicated server area](https://www.returntomoria.com/news-updates/dedicated-server) and the [community Discord](https://www.returntomoria.com/community) for more information
