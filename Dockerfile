FROM elixir:1.12.3-alpine as build

RUN apk add --update git build-base nodejs npm yarn python3

RUN apk add --no-cache build-base git python3 \
    gcc \
    git \
    make \
    musl-dev 

RUN mkdir /app
WORKDIR /app

RUN mix local.rebar --force && \
    mix local.hex --force

ENV MIX_ENV="prod"
ENV PHX_SERVER="true"

COPY mix.exs .
COPY mix.lock .

RUN mix deps.get --only $MIX_ENV
RUN mix deps.compile

COPY lib ./lib

RUN mix compile
RUN mix release 

FROM alpine:3.15.0 AS app

RUN apk add --update bash openssl

RUN apk add --no-cache libstdc++

EXPOSE 4000

ENV MIX_ENV="prod"
ENV PHX_SERVER="true"

RUN mkdir /app
WORKDIR /app

COPY --from=build /app/_build/prod/rel/ddos .
RUN chown -R nobody: /app
USER nobody

ENV HOME=/app

CMD ["/app/bin/ddos", "start"]