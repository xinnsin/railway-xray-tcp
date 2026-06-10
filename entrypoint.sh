#!/bin/sh
set -e

if [ -z "$VLESS_UUID" ]; then
  echo "ERROR: VLESS_UUID is not set"
  exit 1
fi

XRAY_PORT="${XRAY_PORT:-8080}"
WS_PATH="${WS_PATH:-/ray}"

sed \
  -e "s|\${VLESS_UUID}|${VLESS_UUID}|g" \
  -e "s|\${XRAY_PORT}|${XRAY_PORT}|g" \
  -e "s|\${WS_PATH}|${WS_PATH}|g" \
  /etc/xray/config.template.json > /etc/xray/config.json

echo "Starting Xray on port ${XRAY_PORT}, WebSocket path ${WS_PATH}"
/usr/local/bin/xray run -config /etc/xray/config.json &

if [ -n "$TUNNEL_TOKEN" ]; then
  echo "Starting Cloudflare Tunnel"
  exec /usr/local/bin/cloudflared tunnel --no-autoupdate run --token "$TUNNEL_TOKEN"
else
  echo "TUNNEL_TOKEN is not set, only Xray started"
  wait
fi
