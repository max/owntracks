FROM owntracks/frontend:latest
COPY ./config.js /usr/share/nginx/html/config/config.js

RUN apk update && apk add --no-cache \
    ca-certificates iptables ip6tables && \
    rm -rf /var/cache/apk/*

RUN mkdir -p /var/run/tailscale /var/cache/tailscale /var/lib/tailscale

COPY --from=docker.io/tailscale/tailscale:stable /usr/local/bin/tailscaled /usr/local/bin/tailscaled
COPY --from=docker.io/tailscale/tailscale:stable /usr/local/bin/tailscale /usr/local/bin/tailscale

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
