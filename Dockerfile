FROM python:3.11.4-alpine3.18 AS rapidpm-gateway-app-base
WORKDIR /srv
COPY . .
RUN \
	apk update && \
	apk add --no-cache \
		libmagic \
		make \
		curl \
		bash

FROM rapidpm-gateway-app-base AS rapidpm-gateway-app-dev
RUN make dev
CMD ["make", "server-dev"]

FROM rapidpm-gateway-app-base AS rapidpm-gateway-app-prod
RUN make prod
CMD ["make", "server-dev"]

FROM nginx:1.23.4-alpine3.17 AS reverseproxy
COPY proxy/nginx.conf /etc/nginx/nginx.conf
