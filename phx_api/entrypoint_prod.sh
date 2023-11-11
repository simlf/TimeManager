#!/bin/bash
# Docker entrypoint script.

mix local.hex --force && \
    mix local.rebar --force && \
    mix archive.install --force hex phx_new 1.5.1

# Wait until Postgres is ready
echo "Testing if Postgres is accepting connections. {$PGHOST} {$PGPORT} ${PGUSER}"
while ! pg_isready -q -h $PGHOST -p $PGPORT -U $PGUSER
do
  echo "$(date) - waiting for database to start"
  sleep 2
done

# cd phx_api
  MIX_ENV=prod mix deps.get

# Create, migrate, and seed database if it doesn't exist.
if [[ -z `psql -Atqc "\\list $PGDATABASE"` ]]; then
  echo "Database $PGDATABASE does not exist. Creating..."
  MIX_ENV=prod mix ecto.create
  MIX_ENV=prod mix ecto.migrate
  MIX_ENV=prod mix run priv/repo/seeds.exs
  echo "Database $PGDATABASE created."
fi

MIX_ENV=prod exec mix phx.server
