#!/bin/sh

if [ -z "$MQTT_USERNAME" ] || [ -z "$MQTT_PASSWORD" ]; then
    echo "Error: MQTT_USERNAME and MQTT_PASSWORD must be set."
    exit 1
fi

if [ -n "$TAILSCALE_AUTHKEY" ]; then
    echo "TAILSCALE_AUTHKEY is set. Setting up Tailscale."

    /usr/local/bin/tailscaled --state=/var/lib/tailscale/tailscaled.state --socket=/var/run/tailscale/tailscaled.sock &
    /usr/local/bin/tailscale up --auth-key=${TAILSCALE_AUTHKEY} --hostname=owntracks-broker
else
    echo "Warning: TAILSCALE_AUTHKEY not set. Skipping Tailscale."
fi

echo "Creating mosquitto password for $MQTT_USERNAME."
mosquitto_passwd -c -b /mosquitto/config/passwd "$MQTT_USERNAME" "$MQTT_PASSWORD"

chown -R mosquitto:mosquitto /mosquitto

exec mosquitto -c /mosquitto/config/mosquitto.conf
