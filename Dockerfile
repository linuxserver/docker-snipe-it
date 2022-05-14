FROM ghcr.io/linuxserver/baseimage-alpine-nginx:3.15

# set version label
ARG BUILD_DATE
ARG VERSION
ARG SNIPEIT_RELEASE
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="TheLamer"

RUN \
  echo "**** install runtime packages ****" && \
  apk add --no-cache \
    curl \
    libxml2 \
    mariadb-client \
    php8-bcmath \
    php8-ctype \
    php8-curl \
    php8-fileinfo \
    php8-gd \
    php8-iconv \
    php8-ldap \
    php8-mbstring \
    php8-openssl \
    php8-pdo \
    php8-pdo_mysql \
    php8-pdo_sqlite \
    php8-phar \
    php8-sodium \
    php8-sqlite3 \
    php8-tokenizer \
    php8-xml \
    php8-xmlreader \
    php8-zip \
    tar \
    unzip && \
  echo "**** configure php-fpm to pass env vars ****" && \
  sed -i \
    's/;clear_env = no/clear_env = no/g' \
    /etc/php8/php-fpm.d/www.conf && \
  echo "env[PATH] = /usr/local/bin:/usr/bin:/bin" >> /etc/php8/php-fpm.conf && \
  echo "**** install snipe-it ****" && \
  mkdir -p \
    /var/www/html/ && \
  if [ -z ${SNIPEIT_RELEASE+x} ]; then \
    SNIPEIT_RELEASE=$(curl -sX GET "https://api.github.com/repos/snipe/snipe-it/releases/latest" \
    | awk '/tag_name/{print $4;exit}' FS='[""]'); \
  fi && \
  curl -o \
  /tmp/snipeit.tar.gz -L \
    "https://github.com/snipe/snipe-it/archive/${SNIPEIT_RELEASE}.tar.gz" && \
  tar xf \
    /tmp/snipeit.tar.gz -C \
    /var/www/html/ --strip-components=1 && \
  cp /var/www/html/docker/docker.env /var/www/html/.env && \
  echo "**** install dependencies ****" && \
  cd /tmp && \
  curl -sS https://getcomposer.org/installer | php && \
  mv /tmp/composer.phar /usr/local/bin/composer && \
  composer install --no-dev -d /var/www/html && \
  echo "**** move storage directories to defaults ****" && \
  mv \
    "/var/www/html/storage" \
    "/var/www/html/public/uploads" \
  /defaults/ && \
  echo "**** cleanup ****" && \
  rm -rf \
    /root/.composer \
    /tmp/*

# copy local files
COPY root/ /

# ports and volumes
EXPOSE 80 443
