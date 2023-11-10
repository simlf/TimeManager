FROM elixir:latest

# Install debian packages
RUN apt-get update && \
    apt-get install --yes build-essential inotify-tools postgresql-client git && \
    apt-get clean
WORKDIR /phx_api

COPY . /phx_api




RUN chmod o+x entrypoint.sh

ENTRYPOINT [ "/phx_api/entrypoint.sh" ]
