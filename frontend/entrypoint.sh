#!/bin/sh

if [ -n "$TAILSCALE_AUTHKEY" ]; then
    echo "TAILSCALE_AUTHKEY is set. Setting up Tailscale."

    /usr/local/bin/tailscaled --state=/var/lib/tailscale/tailscaled.state --socket=/var/run/tailscale/tailscaled.sock &
    /usr/local/bin/tailscale up --auth-key=${TAILSCALE_AUTHKEY} --hostname=owntracks-frontend
else
    echo "Warning: TAILSCALE_AUTHKEY not set. Skipping Tailscale."
fi

envsubst '${SERVER_HOST} ${SERVER_PORT} ${LISTEN_PORT}' \
  < /etc/nginx/nginx.tmpl \
  > /etc/nginx/nginx.conf

if nginx -g 'daemon off;'; then
  exit 0
else
  env
  cat /etc/nginx/nginx.conf
  exit 1
fi
