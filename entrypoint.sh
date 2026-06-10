#!/bin/sh
set -e

if [ -z "$VLESS_UUID" ]; then
  echo "ERROR: VLESS_UUID is not set"
  exit 1
fi

XRAY_PORT="${XRAY_PORT:-8080}"

sed \
  -e "s|\${VLESS_UUID}|${VLESS_UUID}|g" \
  -e "s|\${XRAY_PORT}|${XRAY_PORT}|g" \
  /etc/xray/config.template.json > /etc/xray/config.json

echo "Starting Xray on port ${XRAY_PORT}"
exec /usr/local/bin/xray run -config /etc/xray/config.json
