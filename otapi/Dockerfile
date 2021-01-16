FROM elixir:1.11

WORKDIR /srv

RUN apt update

RUN mix local.hex --force

RUN mix archive.install hex phx_new 1.5.7 --force

RUN curl -sL https://deb.nodesource.com/setup_lts.x | bash - \
    && apt-get install -y nodejs

RUN apt-get -y install inotify-tools
RUN rm -rf /var/lib/apt/lists/*

RUN mix local.rebar --force

COPY . /srv
RUN cd ./assets && npm install
RUN mix deps.get

ARG GIT_HASH=git_hash

CMD ["mix", "phx.server"]