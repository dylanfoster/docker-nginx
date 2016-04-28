#!/bin/sh
set -e

SERVER_CONF=/etc/nginx/server.conf

if [ -f "$SERVER_CONF" ]; then
  rm $SERVER_CONF
fi

if [ "$SECURE" ]; then
  ln -s /etc/nginx/secure.conf "$SERVER_CONF"
else
  ln -s /etc/nginx/insecure.conf "$SERVER_CONF"
fi

exec "$@"
