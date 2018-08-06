[linuxserverurl]: https://linuxserver.io
[forumurl]: https://forum.linuxserver.io
[ircurl]: https://www.linuxserver.io/irc/
[podcasturl]: https://www.linuxserver.io/podcast/
[appurl]: https://github.com/snipe/snipe-it
[huburl]: https://hub.docker.com/r/linuxserver/snipe-it/
[localesurl]: https://github.com/snipe/snipe-it/tree/master/resources/lang


[![linuxserver.io](https://raw.githubusercontent.com/linuxserver/docker-templates/master/linuxserver.io/img/linuxserver_medium.png?v=4&s=4000)][linuxserverurl]


## Contact information:-

| Type | Address/Details |
| :---: | --- |
| Discord | [Discord](https://discord.gg/YWrKVTn) |
| Forum | [Linuserver.io forum][forumurl] |
| IRC | freenode at `#linuxserver.io` more information at:- [IRC][ircurl]
| Podcast | Covers everything to do with getting the most from your Linux Server plus a focus on all things Docker and containerisation! [Linuxserver.io Podcast][podcasturl] |


The [LinuxServer.io][linuxserverurl] team brings you another image release featuring :-

 + regular and timely application updates
 + easy user mappings
 + custom base image with s6 overlay
 + security updates

# [linuxserver/snipe-it][huburl]
[![](https://images.microbadger.com/badges/version/linuxserver/snipe-it.svg)](https://microbadger.com/images/linuxserver/snipe-it "Get your own version badge on microbadger.com")[![](https://images.microbadger.com/badges/image/linuxserver/snipe-it.svg)](https://microbadger.com/images/linuxserver/snipe-it "Get your own image badge on microbadger.com")[![Docker Pulls](https://img.shields.io/docker/pulls/linuxserver/snipe-it.svg)][huburl][![Docker Stars](https://img.shields.io/docker/stars/linuxserver/snipe-it.svg)][huburl][![Build Status](https://ci.linuxserver.io/job/Docker-Pipeline-Builders/job/docker-snipe-it/job/master/badge/icon)](https://ci.linuxserver.io/job/Docker-Pipeline-Builders/job/docker-snipe-it/job/master/)[![CI Status](https://lsio-ci.ams3.digitaloceanspaces.com/linuxserver/snipe-it/latest/badge.svg)](https://lsio-ci.ams3.digitaloceanspaces.com/linuxserver/snipe-it/latest/index.html)

Snipe-IT makes asset management easy. It was built by people solving real-world IT and asset management problems, and a solid UX has always been a top priority. Straightforward design and bulk actions mean getting things done faster.

[![snipe-it](https://s3-us-west-2.amazonaws.com/linuxserver-docs/images/snipe-it-logo500x500.png)][appurl]

&nbsp;

## Usage

```
docker create \
  --name=snipe-it \
  -v <path to data>:/config \
  -e APP_URL=<hostname or ip> \
  -e MYSQL_PORT_3306_TCP_ADDR=<mysql host> \
  -e MYSQL_DATABASE=<mysql database> \
  -e MYSQL_USER=<mysql user> \
  -e MYSQL_PASSWORD=<mysql pass> \
  -e PGID=<gid> -e PUID=<uid>  \
  -p 8080:80 \
  linuxserver/snipe-it
```

&nbsp;

## Required Parameters

The parameters are split into two halves, separated by a colon, the left hand side representing the host and the right the container side.
For example with a port -p external:internal - what this shows is the port mapping from internal to external of the container.
So -p 8080:80 would expose port 80 from inside the container to be accessible from the host's IP on port 8080
http://192.168.x.x:8080 would show you what's running INSIDE the container on port 80.



| Parameter | Function |
| :---: | --- |
| `-p 8080` | the port(s) |
| `-v /config` | Contains your config files and data storage for Snipe-IT|
| `-e APP_URL=` | Hostname or IP and port if applicable IE 192.168.10.1:8080 |
| `-e MYSQL_PORT_3306_TCP_ADDR=` | Mysql hostname or IP to use|
| `-e MYSQL_DATABASE=` | Mysql database to use|
| `-e MYSQL_USER=` | Mysql user to use|
| `-e MYSQL_PASSWORD=` | Mysql password to use|
| `-e PGID` | for GroupID, see below for explanation |
| `-e PUID` | for UserID, see below for explanation |

&nbsp;

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


&nbsp;

## User / Group Identifiers

Sometimes when using volumes (`-v` flags) permissions issues can arise between the host OS and the container, we avoid this issue by allowing you to specify the user `PUID` and group `PGID`.

Ensure any volume directories on the host are owned by the same user you specify and it will "just work" &trade;.

In this instance `PUID=1001` and `PGID=1001`, to find yours use `id user` as below:

```
  $ id <dockeruser>
    uid=1001(dockeruser) gid=1001(dockergroup) groups=1001(dockergroup)
```

&nbsp;

## Setting up the application

Access the webui at `<your-ip>:8080`, for more information check out [snipe-it][appurl].

&nbsp;

## Container access and information.

| Function | Command |
| :--- | :--- |
| Shell access (live container) | `docker exec -it snipe-it /bin/bash` |
| Realtime container logs | `docker logs -f snipe-it` |
| Container version number | `docker inspect -f '{{ index .Config.Labels "build_version" }}' snipe-it` |
| Image version number |  `docker inspect -f '{{ index .Config.Labels "build_version" }}' linuxserver/snipe-it` |

&nbsp;

## Supported Architectures

Our images support multiple architectures such as `X86-64`, `arm64` and `armhf`. We utilise the docker manifest for multi-platform awareness. More information is available from docker [here](https://github.com/docker/distribution/blob/master/docs/spec/manifest-v2-2.md#manifest-list).

The architectures supported by this image are:

| Architecture | Tag |
| :----: | --- |
| X86-64 | amd64-latest |
| arm64 | arm32v6-latest |
| armhf | arm64v8-latest |

You can use the "latest" tag on any architecture, the docker client will automatically pull the correct image.

&nbsp;

## Versions

|  Date | Changes |
| :---: | --- |
| 05.08.18 |  Migration to live build server. |
| 13.06.18 |  Initial Release. |
