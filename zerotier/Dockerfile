
FROM debian:bullseye-slim as builder

RUN apt update && apt install -y curl
RUN curl -s "https://raw.githubusercontent.com/zerotier/ZeroTierOne/master/doc/contact%40zerotier.com.gpg" > /etc/apt/trusted.gpg.d/zerotier.asc && \
    echo "deb https://download.zerotier.com/debian/bullseye bullseye main" > /etc/apt/sources.list.d/zerotier.list
RUN apt update && apt install -y zerotier-one



FROM frolvlad/alpine-glibc:latest

RUN apk add --update libstdc++

RUN mkdir -p /var/lib/zerotier-one
COPY --from=builder /usr/sbin/zerotier-one /usr/sbin/zerotier-one
COPY --from=builder /usr/sbin/zerotier-cli /usr/sbin/zerotier-cli
COPY --from=builder /usr/sbin/zerotier-idtool /usr/sbin/zerotier-idtool



COPY ./docker-entry.sh /docker-entry.sh
RUN chmod 755 /docker-entry.sh

# ZeroTier relies on UDP port 9993
EXPOSE 9993/udp

CMD ["/docker-entry.sh"]
