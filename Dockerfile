# syntax=docker/dockerfile:1

FROM ghcr.io/linuxserver/baseimage-alpine-nginx:3.18

# set version label
ARG BUILD_DATE
ARG VERSION
ARG SNIPEIT_RELEASE
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="TheLamer"

RUN \
  echo "**** install runtime packages ****" && \
  apk add --no-cache \
    libxml2 \
    mariadb-client \
    php82-bcmath \
    php82-gd \
    php82-ldap \
    php82-pdo_mysql \
    php82-pdo_sqlite \
    php82-pecl-redis \
    php82-sodium \
    php82-sqlite3 \
    php82-tokenizer \
    php82-xmlreader && \
  apk add --no-cache --repository=http://dl-cdn.alpinelinux.org/alpine/edge/testing \
    php82-pecl-mcrypt && \
  echo "**** configure php-fpm to pass env vars ****" && \
  sed -E -i 's/^;?clear_env ?=.*$/clear_env = no/g' /etc/php82/php-fpm.d/www.conf && \
  grep -qxF 'clear_env = no' /etc/php82/php-fpm.d/www.conf || echo 'clear_env = no' >> /etc/php82/php-fpm.d/www.conf && \
  echo "env[PATH] = /usr/local/bin:/usr/bin:/bin" >> /etc/php82/php-fpm.conf && \
  echo "**** install snipe-it ****" && \
  mkdir -p \
    /app/www/ && \
  if [ -z ${SNIPEIT_RELEASE+x} ]; then \
    SNIPEIT_RELEASE=$(curl -sX GET "https://api.github.com/repos/snipe/snipe-it/releases/latest" \
    | awk '/tag_name/{print $4;exit}' FS='[""]'); \
  fi && \
  curl -o \
    /tmp/snipeit.tar.gz -L \
    "https://github.com/snipe/snipe-it/archive/${SNIPEIT_RELEASE}.tar.gz" && \
  tar xf \
    /tmp/snipeit.tar.gz -C \
    /app/www/ --strip-components=1 && \
  cp /app/www/docker/docker.env /app/www/.env && \
  composer install --no-dev -d /app/www && \
  echo "**** move storage directories to defaults ****" && \
  mv \
    "/app/www/storage" \
    "/app/www/public/uploads" \
    /defaults/ && \
  echo "**** cleanup ****" && \
  rm -rf \
    /tmp/* \
    $HOME/.cache \
    $HOME/.composer

# copy local files
COPY root/ /

# ports and volumes
EXPOSE 80 443
VOLUME /config
