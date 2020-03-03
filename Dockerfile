FROM basex/basexhttp:9.1
LABEL maintainer="mblissett@gbif.org"

USER root
RUN apk update && apk add --no-cache python3 py3-requests supervisor varnish shadow

# Use a different directory for BaseX, because the /srv directory is declared a non-persistent volume.
RUN cp -pr /srv /basex
RUN usermod -d /basex basex
WORKDIR /basex

# BaseX script
COPY html/restxq.xqm /basex/basex/webapp

# Initialize the database (sets password, starts up, imports data, shuts down)
COPY . /usr/src/
USER basex
RUN /usr/src/docker/initialize-database.sh ../ '' http://localhost:8984/rest/
USER root
RUN rm -Rf /usr/src/

COPY docker/supervisord.conf /etc/supervisord.conf
COPY docker/varnish_default.vcl /etc/varnish/default.vcl

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]
