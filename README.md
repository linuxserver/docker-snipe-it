[![linuxserver.io](https://raw.githubusercontent.com/linuxserver/docker-templates/master/linuxserver.io/img/linuxserver_medium.png)](https://linuxserver.io)

The [LinuxServer.io](https://linuxserver.io) team brings you another container release featuring :-

 * regular and timely application updates
 * easy user mappings (PGID, PUID)
 * custom base image with s6 overlay
 * weekly base OS updates with common layers across the entire LinuxServer.io ecosystem to minimise space usage, down time and bandwidth
 * regular security updates

Find us at:
* [Discord](https://discord.gg/YWrKVTn) - realtime support / chat with the community and the team.
* [IRC](https://irc.linuxserver.io) - on freenode at `#linuxserver.io`. Our primary support channel is Discord.
* [Blog](https://blog.linuxserver.io) - all the things you can do with our containers including How-To guides, opinions and much more!

# [linuxserver/snipe-it](https://github.com/linuxserver/docker-snipe-it)
[![](https://img.shields.io/discord/354974912613449730.svg?logo=discord&label=LSIO%20Discord&style=flat-square)](https://discord.gg/YWrKVTn)
[![](https://images.microbadger.com/badges/version/linuxserver/snipe-it.svg)](https://microbadger.com/images/linuxserver/snipe-it "Get your own version badge on microbadger.com")
[![](https://images.microbadger.com/badges/image/linuxserver/snipe-it.svg)](https://microbadger.com/images/linuxserver/snipe-it "Get your own version badge on microbadger.com")
![Docker Pulls](https://img.shields.io/docker/pulls/linuxserver/snipe-it.svg)
![Docker Stars](https://img.shields.io/docker/stars/linuxserver/snipe-it.svg)
[![Build Status](https://ci.linuxserver.io/buildStatus/icon?job=Docker-Pipeline-Builders/docker-snipe-it/master)](https://ci.linuxserver.io/job/Docker-Pipeline-Builders/job/docker-snipe-it/job/master/)
[![](https://lsio-ci.ams3.digitaloceanspaces.com/linuxserver/snipe-it/latest/badge.svg)](https://lsio-ci.ams3.digitaloceanspaces.com/linuxserver/snipe-it/latest/index.html)

[Snipe-it](https://github.com/snipe/snipe-it) makes asset management easy. It was built by people solving real-world IT and asset management problems, and a solid UX has always been a top priority. Straightforward design and bulk actions mean getting things done faster.

[![snipe-it](https://s3-us-west-2.amazonaws.com/linuxserver-docs/images/snipe-it-logo500x500.png)](https://github.com/snipe/snipe-it)

## Supported Architectures

Our images support multiple architectures such as `x86-64`, `arm64` and `armhf`. We utilise the docker manifest for multi-platform awareness. More information is available from docker [here](https://github.com/docker/distribution/blob/master/docs/spec/manifest-v2-2.md#manifest-list) and our announcement [here](https://blog.linuxserver.io/2019/02/21/the-lsio-pipeline-project/). 

Simply pulling `linuxserver/snipe-it` should retrieve the correct image for your arch, but you can also pull specific arch images via tags.

The architectures supported by this image are:

| Architecture | Tag |
| :----: | --- |
| x86-64 | amd64-latest |
| arm64 | arm64v8-latest |
| armhf | arm32v7-latest |


## Usage

Here are some example snippets to help you get started creating a container.

### docker

```
docker create \
  --name=snipe-it \
  -e PUID=1000 \
  -e PGID=1000 \
  -e APP_URL=<hostname or ip> \
  -e MYSQL_PORT_3306_TCP_ADDR=<mysql host> \
  -e MYSQL_PORT_3306_TCP_PORT=<mysql port> \
  -e MYSQL_DATABASE=<mysql database> \
  -e MYSQL_USER=<mysql pass> \
  -e MYSQL_PASSWORD=changeme \
  -p 8080:80 \
  -v <path to snipe-it data>:/config \
  --restart unless-stopped \
  linuxserver/snipe-it
```


### docker-compose

Compatible with docker-compose v2 schemas.

```
version: "3"
services:
  mysql:
    image: mysql:5
    container_name: snipe_mysql
    restart: always
    volumes:
      - <path to mysql data>:/var/lib/mysql
    environment:
      - MYSQL_ROOT_PASSWORD=<secret password>
      - MYSQL_USER=snipe
      - MYSQL_PASSWORD=<secret user password>
      - MYSQL_DATABASE=snipe
  snipeit:
    image: linuxserver/snipe-it:latest
    container_name: snipe-it
    restart: always
    depends_on:
      - mysql
    volumes:
      - <path to data>:/config
    environment:
      - APP_URL=< your application URL IE 192.168.10.1:8080>
      - MYSQL_PORT_3306_TCP_ADDR=mysql
      - MYSQL_PORT_3306_TCP_PORT=3306
      - MYSQL_DATABASE=snipe
      - MYSQL_USER=snipe
      - MYSQL_PASSWORD=<secret user password>
      - PGID=1000
      - PUID=1000
    ports:
      - "8080:80"

```

## Parameters

Container images are configured using parameters passed at runtime (such as those above). These parameters are separated by a colon and indicate `<external>:<internal>` respectively. For example, `-p 8080:80` would expose port `80` from inside the container to be accessible from the host's IP on port `8080` outside the container.

| Parameter | Function |
| :----: | --- |
| `-p 80` | Snipe-IT Web UI |
| `-e PUID=1000` | for UserID - see below for explanation |
| `-e PGID=1000` | for GroupID - see below for explanation |
| `-e APP_URL=<hostname or ip>` | Hostname or IP and port if applicable IE <ip or hostname>:8080 |
| `-e MYSQL_PORT_3306_TCP_ADDR=<mysql host>` | Mysql hostname or IP to use |
| `-e MYSQL_PORT_3306_TCP_PORT=<mysql port>` | Mysql port to use |
| `-e MYSQL_DATABASE=<mysql database>` | Mysql database to use |
| `-e MYSQL_USER=<mysql pass>` | Mysql user to use |
| `-e MYSQL_PASSWORD=changeme` | Mysql password to use |
| `-v /config` | Contains your config files and data storage for Snipe-IT |

## Optional Parameters

This container also generates an SSL certificate and stores it in
```
/config/keys/cert.crt
/config/keys/key.crt
```
To use your own certificate swap these files with yours. To use SSL forward your port to 443 inside the container IE:

```
-p 443:443
```

The application accepts a series of environment variables to further customize itself on boot:

| Parameter | Function |
| :---: | --- |
| `-e APP_TIMEZONE=` | The timezone the application will use IE US/Pacific|
| `-e APP_ENV=` | Default is production but can use testing or develop|
| `-e APP_DEBUG=` | Set to true to see debugging output in the web UI|
| `-e APP_LOCALE=` | Default is en set to the language preferred full list [here][localesurl]|
| `-e MAIL_PORT_587_TCP_ADDR=` | SMTP mailserver ip or hostname|
| `-e MAIL_PORT_587_TCP_PORT=` | SMTP mailserver port|
| `-e MAIL_ENV_FROM_ADDR=` | The email address mail should be replied to and listed when sent|
| `-e MAIL_ENV_FROM_NAME=` | The name listed on email sent from the default account on the system|
| `-e MAIL_ENV_ENCRYPTION=` | Mail encryption to use IE tls |
| `-e MAIL_ENV_USERNAME=` | SMTP server login username|
| `-e MAIL_ENV_PASSWORD=` | SMTP server login password|


## User / Group Identifiers

When using volumes (`-v` flags) permissions issues can arise between the host OS and the container, we avoid this issue by allowing you to specify the user `PUID` and group `PGID`.

Ensure any volume directories on the host are owned by the same user you specify and any permissions issues will vanish like magic.

In this instance `PUID=1000` and `PGID=1000`, to find yours use `id user` as below:

```
  $ id username
    uid=1000(dockeruser) gid=1000(dockergroup) groups=1000(dockergroup)
```


&nbsp;
## Application Setup

Access the webui at `<your-ip>:8080`, for more information check out [Snipe-it](https://github.com/snipe/snipe-it).



## Support Info

* Shell access whilst the container is running: `docker exec -it snipe-it /bin/bash`
* To monitor the logs of the container in realtime: `docker logs -f snipe-it`
* container version number 
  * `docker inspect -f '{{ index .Config.Labels "build_version" }}' snipe-it`
* image version number
  * `docker inspect -f '{{ index .Config.Labels "build_version" }}' linuxserver/snipe-it`

## Updating Info

Most of our images are static, versioned, and require an image update and container recreation to update the app inside. With some exceptions (ie. nextcloud, plex), we do not recommend or support updating apps inside the container. Please consult the [Application Setup](#application-setup) section above to see if it is recommended for the image.  
  
Below are the instructions for updating containers:  
  
### Via Docker Run/Create
* Update the image: `docker pull linuxserver/snipe-it`
* Stop the running container: `docker stop snipe-it`
* Delete the container: `docker rm snipe-it`
* Recreate a new container with the same docker create parameters as instructed above (if mapped correctly to a host folder, your `/config` folder and settings will be preserved)
* Start the new container: `docker start snipe-it`
* You can also remove the old dangling images: `docker image prune`

### Via Taisun auto-updater (especially useful if you don't remember the original parameters)
* Pull the latest image at its tag and replace it with the same env variables in one shot:
  ```
  docker run --rm \
  -v /var/run/docker.sock:/var/run/docker.sock taisun/updater \
  --oneshot snipe-it
  ```
* You can also remove the old dangling images: `docker image prune`

### Via Docker Compose
* Update all images: `docker-compose pull`
  * or update a single image: `docker-compose pull snipe-it`
* Let compose update all containers as necessary: `docker-compose up -d`
  * or update a single container: `docker-compose up -d snipe-it`
* You can also remove the old dangling images: `docker image prune`

## Versions

* **23.03.19:** - Switching to new Base images, shift to arm32v7 tag.
* **22.02.19:** - Rebasing to alpine 3.9.
* **31.10.18:** - Rebasing to alpine 3.8
* **05.08.18:** - Migration to live build server.
* **13.06.18:** - Initial Release.
