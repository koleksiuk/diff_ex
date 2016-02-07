FROM iron/elixir
WORKDIR /app
ADD . /app
ENTRYPOINT [ "mix", "test" ]
