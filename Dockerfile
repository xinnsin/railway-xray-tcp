FROM ghcr.io/xtls/xray-core:latest AS xray

FROM alpine:3.20

RUN apk add --no-cache ca-certificates tzdata

COPY --from=xray /usr/local/bin/xray /usr/local/bin/xray
COPY config.template.json /etc/xray/config.template.json
COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

EXPOSE 8080

ENTRYPOINT ["/entrypoint.sh"]
