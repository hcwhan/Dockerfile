FROM alpine:latest

ENV VERSION=1.2.0

RUN apk add --no-cache --update-cache --update wget && \
    wget "https://github.com/IrineSistiana/mos-chinadns/releases/download/v${VERSION}/mos-chinadns-linux-amd64.zip" && \
    mkdir /mos-chinadns && \
    unzip "mos-chinadns-linux-amd64.zip" -d /mos-chinadns && \
    rm -rf "mos-chinadns-linux-amd64.zip" && \
    chmod +x /mos-chinadns/mos-chinadns && ls -al && \
    apk del wget && \
    rm -rf /tmp/* /var/cache/apk/*

RUN mkdir -p /config && \
    rm /mos-chinadns/config.yaml && \
    ln -s /config/config.yaml /mos-chinadns/config.yaml

CMD ["/mos-chinadns/mos-chinadns", "-dir2exe", "-c", "/mos-chinadns/config.yaml"]
