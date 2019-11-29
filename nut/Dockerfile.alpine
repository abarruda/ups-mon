FROM arm32v7/alpine:3.10.3

ARG NUT_VERSION=2.7.4-r6

RUN echo '@edge http://dl-cdn.alpinelinux.org/alpine/edge/main' >> /etc/apk/repositories && \
    echo '@testing http://dl-cdn.alpinelinux.org/alpine/edge/testing' >>/etc/apk/repositories 

RUN apk add --update \
	nut@testing=$NUT_VERSION \
	libcrypto1.1@edge \
	libssl1.1@edge \
	net-snmp-libs@edge


RUN mkdir /var/run/nut

CMD upsdrvctl -D -u root start && \
	upsd -u root && \
	sleep 2 && \
	upsc CyberPower-1400VA@localhost && \
	upsmon 