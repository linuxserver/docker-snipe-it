FROM ghcr.io/linuxserver/baseimage-alpine-nginx:3.15

# set version label
ARG BUILD_DATE
ARG VERSION
ARG SNIPEIT_RELEASE
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="TheLamer"

RUN \
  echo "**** install build packages ****" && \
  apk add --no-cache --virtual=build-dependencies \
    composer && \
  echo "**** install runtime packages ****" && \
  apk add --no-cache \
    curl \
    libxml2 \
    mariadb-client \
    php8-bcmath \
    php8-ctype \
    php8-curl \
    php8-gd \
    php8-iconv \
    php8-ldap \
    php8-mbstring \
    php8-pdo_mysql \
    php8-pdo_sqlite \
    php8-pecl-mcrypt \
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
  sed -E -i 's/^;?clear_env ?=.*$/clear_env = no/g' /etc/php8/php-fpm.d/www.conf && \
  grep -qxF 'clear_env = no' /etc/php8/php-fpm.d/www.conf || echo 'clear_env = no' >> /etc/php8/php-fpm.d/www.conf && \
  echo "env[PATH] = /usr/local/bin:/usr/bin:/bin" >> /etc/php8/php-fpm.conf && \
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
  apk del --purge \
    build-dependencies && \
  rm -rf \
    /root/.composer \
    /tmp/*

# copy local files
COPY root/ /

# ports and volumes
EXPOSE 80 443
VOLUME /config
