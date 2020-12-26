FROM elixir:1.11

WORKDIR /srv

RUN apt update \
    && rm -rf /var/lib/apt/lists/*

RUN mix local.hex --force

RUN mix archive.install hex phx_new 1.5.7 --force

RUN curl -sL https://deb.nodesource.com/setup_lts.x | bash - \
    && apt-get install -y nodejs

RUN mix local.rebar --force

CMD ["mix", "phx.server"]