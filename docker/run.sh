#!/bin/sh

docker run --rm -it -v "$PWD":/app -w /app iron/elixir mix deps.get
docker run --rm -it -v "$PWD":/app -w /app iron/elixir mix test
