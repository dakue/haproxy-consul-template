FROM alpine:latest

ENV CONSUL_TEMPLATE_VERSION=0.12.0 \
  CONSUL_TEMPLATE_HOME="/opt/consul-template"

RUN set -x && \ 
  apk --update add bash tar unzip curl ca-certificates haproxy && \
  rm -rf /var/cache/apk/*

RUN set -x && \
  curl -sSL "https://releases.hashicorp.com/consul-template/${CONSUL_TEMPLATE_VERSION}/consul-template_${CONSUL_TEMPLATE_VERSION}_linux_amd64.zip" -o /usr/local/bin/consul-template.zip && \
  cd /usr/local/bin && unzip consul-template.zip && \
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
