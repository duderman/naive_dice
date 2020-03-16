ARG ALPINE_VERSION=3.11

FROM elixir:1.10.2-alpine AS builder

ARG APP_NAME
ARG APP_VSN
ARG MIX_ENV=prod

ENV APP_NAME=${APP_NAME} \
  APP_VSN=${APP_VSN} \
  MIX_ENV=${MIX_ENV}

WORKDIR /opt/app

RUN \
  apk update && \
  apk upgrade --no-cache && \
  apk add --no-cache nodejs yarn git build-base && \
  mix local.rebar --force && \
  mix local.hex --force

COPY mix.* ./

RUN mix do deps.get, deps.compile

COPY assets/package.json ./assets/
COPY assets/yarn.lock ./assets/

RUN \
  cd assets && \
  yarn install

COPY assets assets/

RUN \
  cd assets && \
  yarn deploy

COPY . .

RUN mix do compile, phx.digest

RUN \
  mkdir -p /opt/built && \
  mix distillery.release --verbose && \
  cp _build/${MIX_ENV}/rel/${APP_NAME}/releases/${APP_VSN}/${APP_NAME}.tar.gz /opt/built && \
  cd /opt/built && \
  tar -xzf ${APP_NAME}.tar.gz && \
  rm ${APP_NAME}.tar.gz

FROM alpine:${ALPINE_VERSION}

ARG APP_NAME

RUN apk update && \
  apk add --no-cache \
  bash \
  openssl-dev

ENV REPLACE_OS_VARS=true \
  APP_NAME=${APP_NAME}

WORKDIR /opt/app

COPY --from=builder /opt/built .

EXPOSE 4000

CMD /opt/app/bin/${APP_NAME} foreground
