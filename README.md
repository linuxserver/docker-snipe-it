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
* [Podcast](https://anchor.fm/linuxserverio) - on hiatus. Coming back soon (late 2018).

# PSA: Changes are happening

From August 2018 onwards, Linuxserver are in the midst of switching to a new CI platform which will enable us to build and release multiple architectures under a single repo. To this end, existing images for `arm64` and `armhf` builds are being deprecated. They are replaced by a manifest file in each container which automatically pulls the correct image for your architecture. You'll also be able to pull based on a specific architecture tag.

TLDR: Multi-arch support is changing from multiple repos to one repo per container image.

# [linuxserver/snipe-it](https://github.com/linuxserver/docker-snipe-it)
[![](https://images.microbadger.com/badges/version/linuxserver/snipe-it.svg)](https://microbadger.com/images/linuxserver/snipe-it "Get your own version badge on microbadger.com")
[![](https://images.microbadger.com/badges/image/linuxserver/snipe-it.svg)](https://microbadger.com/images/linuxserver/snipe-it "Get your own version badge on microbadger.com")
![Docker Pulls](https://img.shields.io/docker/pulls/linuxserver/snipe-it.svg)
![Docker Stars](https://img.shields.io/docker/stars/linuxserver/snipe-it.svg)

[Snipe-it](https://github.com/snipe/snipe-it) makes asset management easy. It was built by people solving real-world IT and asset management problems, and a solid UX has always been a top priority. Straightforward design and bulk actions mean getting things done faster.

[![snipe-it](https://s3-us-west-2.amazonaws.com/linuxserver-docs/images/snipe-it-logo500x500.png)](https://github.com/snipe/snipe-it)

## Supported Architectures

Our images support multiple architectures such as `X86-64`, `arm64` and `armhf`. We utilise the docker manifest for multi-platform awareness. More information is available from docker [here](https://github.com/docker/distribution/blob/master/docs/spec/manifest-v2-2.md#manifest-list). 

The architectures supported by this image are:

| Architecture | Tag |
| :----: | --- |
| X86-64 | amd64-latest |
| arm64 | arm64v8-latest |
| armhf | arm32v6-latest |

## Usage

Here are some example snippets to help you get started creating a container.

### docker

```
docker create \
  --name=snipe-it \
  -e PUID=1001 \
  -e PGID=1001 \
  -e APP_URL=<hostname or ip> \
  -e MYSQL_PORT_3306_TCP_ADDR=<mysql host> \
  -e MYSQL_PORT_3306_TCP_PORT=<mysql port> \
  -e MYSQL_DATABASE=<mysql database> \
  -e MYSQL_USER=<mysql pass> \
  -e MYSQL_PASSWORD=changeme \
  -p 8080:80 \
  -v <path to snipe-it data>:/config \
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
| `-e PUID=1001` | for UserID - see below for explanation |
| `-e PGID=1001` | for GroupID - see below for explanation |
| `-e APP_URL=<hostname or ip>` | Hostname or IP and port if applicable IE 192.168.10.1:8080 |
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

In this instance `PUID=1001` and `PGID=1001`, to find yours use `id user` as below:

```
  $ id username
    uid=1001(dockeruser) gid=1001(dockergroup) groups=1001(dockergroup)
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

## Versions

* **31.10.18:** - Rebasing to alpine 3.8
* **05.08.18:** - Migration to live build server.
* **13.06.18:** - Initial Release.
