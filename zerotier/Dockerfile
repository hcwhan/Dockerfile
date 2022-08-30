
FROM alpine:latest

RUN apk --update add zerotier-one && \
    rm -rf /var/cache/apk/*

COPY ./docker-entry.sh /docker-entry.sh
RUN chmod 755 /docker-entry.sh

EXPOSE 9993/udp

CMD ["/docker-entry.sh"]
