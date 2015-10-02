FROM alpine:3.2

ENV CONSUL_TEMPLATE_VERSION=0.10.0 \
  CONSUL_TEMPLATE_HOME="/opt/consul-template"

RUN set -x && \ 
  apk --update add bash tar curl ca-certificates haproxy && \
  rm -rf /var/cache/apk/*

RUN set -x && \
  curl -sSL "https://github.com/hashicorp/consul-template/releases/download/v${CONSUL_TEMPLATE_VERSION}/consul-template_${CONSUL_TEMPLATE_VERSION}_linux_amd64.tar.gz" \
  | tar xz --strip-components=1 -C /usr/local/bin && \
  chown root:root /usr/local/bin/consul-template && \
  chmod +x /usr/local/bin/consul-template && \
  mkdir -p ${CONSUL_TEMPLATE_HOME}/config && \
  mkdir -p ${CONSUL_TEMPLATE_HOME}/template.d

ADD config/* ${CONSUL_TEMPLATE_HOME}/config/
ADD template/* ${CONSUL_TEMPLATE_HOME}/template.d/

ADD docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh

EXPOSE 80 443

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["haproxy"]
