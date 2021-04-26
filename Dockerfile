FROM ubuntu:trusty

MAINTAINER Tom Fenton <tom@mediasuite.co.nz>

# no tty
ARG DEBIAN_FRONTEND=noninteractive

ARG OSM_VER=0.7.56.3
ENV EXEC_DIR=/srv/osm3s
ENV DB_DIR=/srv/osm3s/db

RUN build_deps="g++ make expat libexpat1-dev zlib1g-dev curl" \
  && set -x \
  && echo "#!/bin/sh\nexit 0" >/usr/sbin/policy-rc.d \
  && apt-get update \
  && apt-get install -y --force-yes --no-install-recommends \
       $build_deps \
       fcgiwrap \
       nginx \
  && rm /etc/nginx/sites-enabled/default /etc/nginx/sites-available/default \
  && rm -rf /var/lib/apt/lists/* \
  && curl -o osm-3s_v$OSM_VER.tar.gz http://dev.overpass-api.de/releases/osm-3s_v$OSM_VER.tar.gz \
  && tar -zxvf osm-3s_v${OSM_VER}.tar.gz \
  && cd osm-3s_v* \
  && ./configure CXXFLAGS="-O3" --prefix="$EXEC_DIR" \
  && make install \
  && sed -i 's/update_database /update_database --flush-size=1 /' /srv/osm3s/bin/init_osm3s.sh \
  && cd .. \
  && rm -rf osm-3s_v* \
  && apt-get purge -y --auto-remove $build_deps

WORKDIR /usr/src/app

ARG PLANET_FILE=planet.osm.bz2

COPY planet.osm.bz2 .

RUN /srv/osm3s/bin/init_osm3s.sh "$PLANET_FILE" "$DB_DIR" "$EXEC_DIR" \
  && rm -f "$PLANET_FILE"

COPY nginx.conf /etc/nginx/nginx.conf
COPY overpass /etc/init.d
COPY docker-start /usr/local/sbin

CMD ["/usr/local/sbin/docker-start"]

EXPOSE 81
