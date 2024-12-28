FROM eclipse-mosquitto:latest

RUN apk update && apk add --no-cache \
    ca-certificates iptables ip6tables && \
    rm -rf /var/cache/apk/*

RUN mkdir -p /var/run/tailscale /var/cache/tailscale /var/lib/tailscale

COPY --from=docker.io/tailscale/tailscale:stable /usr/local/bin/tailscaled /usr/local/bin/tailscaled
COPY --from=docker.io/tailscale/tailscale:stable /usr/local/bin/tailscale /usr/local/bin/tailscale

WORKDIR /mosquitto

COPY ./mosquitto.conf /mosquitto/config/
COPY ./entrypoint.sh .

RUN chmod +x entrypoint.sh

EXPOSE 1883

CMD ["/mosquitto/entrypoint.sh"]
