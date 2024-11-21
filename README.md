# rnd images

## Initiate Postgres environment
| OS  | Command |
| --- | ------- |
| Debian | <pre lang="powershell">devcontainer templates apply -t ghcr.io/bagermen/rnd-images/postgres-env -w .</pre>  |
| Ubuntu | <pre lang="powershell">devcontainer templates apply -t ghcr.io/bagermen/rnd-images/postgres-env -a '{"os": "-noble"}' -w .</pre>  |
