#!/bin/sh

if [ -z "$MQTT_USERNAME" ] || [ -z "$MQTT_PASSWORD" ]; then
    echo "Error: MQTT_USERNAME and MQTT_PASSWORD must be set"
    exit 1
fi

if [ -z "$TAILSCALE_AUTHKEY" ]; then
    echo "Error: TAILSCALE_AUTHKEY must be set"
    exit 1
fi

echo "Creating mosquitto password for $MQTT_USERNAME"
mosquitto_passwd -c -b /mosquitto/config/passwd "$MQTT_USERNAME" "$MQTT_PASSWORD"

# Ensure permissions are correct
chown -R mosquitto:mosquitto /mosquitto

# Run Tailscale
/usr/local/bin/tailscaled --state=/var/lib/tailscale/tailscaled.state --socket=/var/run/tailscale/tailscaled.sock &
/usr/local/bin/tailscale up --auth-key=${TAILSCALE_AUTHKEY} --hostname=mqtt

# Run Mosquitto in the foreground
exec mosquitto -c /mosquitto/config/mosquitto.conf
