#!/bin/sh
set -eu

if [ -z "${VLESS_UUID:-}" ]; then
  echo "ERROR: VLESS_UUID is not set. Set it in Railway Variables." >&2
  exit 1
fi

XRAY_PORT="${XRAY_PORT:-8080}"

sed \
  -e "s|\${VLESS_UUID}|${VLESS_UUID}|g" \
  -e "s|\${XRAY_PORT}|${XRAY_PORT}|g" \
  /etc/xray/config.template.json > /etc/xray/config.json

if command -v xray >/dev/null 2>&1; then
  exec xray run -config /etc/xray/config.json
fi

if [ -x /usr/bin/xray ]; then
  exec /usr/bin/xray run -config /etc/xray/config.json
fi

if [ -x /usr/local/bin/xray ]; then
  exec /usr/local/bin/xray run -config /etc/xray/config.json
fi

echo "ERROR: xray binary not found in image." >&2
exit 1
