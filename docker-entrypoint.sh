#!/bin/bash
set -e

if [ "$1" = 'haproxy' ]
then
    if [ -n "$CONSUL_PORT_8500_TCP" ]
    then
        if [ -z "$CONSUL_HOST" ]
        then
            export CONSUL_HOST='consul'
            export CONSUL_PORT='8500'
            echo "INFO: setting CONSUL_HOST to $CONSUL_HOST and"
            echo "  CONSUL_PORT to $CONSUL_PORT"
        else
            echo >&2 'WARNING: both CONSUL_HOST and CONSUL_PORT_8500_TCP found'
            echo >&2 "  Connecting to CONSUL_HOST ($CONSUL_HOST)"
            echo >&2 '  instead of the linked consul container'
        fi
    fi

    if [ -z "$CONSUL_HOST" ]
    then
        echo >&2 'ERROR: missing CONSUL_HOST and CONSUL_PORT_8500_TCP environment variables'
        echo >&2 '  Did you forget to --link some_consul_container:consul or set an external host'
        echo >&2 '  with -e CONSUL_HOST=hostname?'
        exit 1
    fi

    if [ -z "$CONSUL_PORT" ] && [ ! -z "$CONSUL_HOST" ]
    then
        echo >&2 'WARNING: setting CONSUL_PORT environment variable to default value 8500'
        export CONSUL_PORT="8500"
    fi

    cp /etc/haproxy/haproxy.cfg /etc/haproxy/haproxy.cfg.defaul

    echo "INFO: Starting Consul ..."
    exec /usr/local/bin/consul-template -config $CONSUL_TEMPLATE_HOME/config -consul $CONSUL_HOST:$CONSUL_PORT
fi

exec "$@"
