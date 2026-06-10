FROM ghcr.io/xtls/xray-core:latest

ENV XRAY_PORT=8080

COPY config.template.json /etc/xray/config.template.json
COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
