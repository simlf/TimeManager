FROM elixir:latest

# Install debian packages
RUN apt-get update && \
    apt-get install --yes build-essential inotify-tools postgresql-client git && \
    apt-get clean

COPY . /phx_api
COPY entrypoint.sh /entrypoint.sh
RUN chmod u+x /entrypoint.sh

# Install Phoenix packages
RUN mix local.hex --force && \
    mix local.rebar --force && \
    mix archive.install --force hex phx_new 1.5.1

WORKDIR /phx_api

EXPOSE 4000

CMD ["/entrypoint.sh"]
