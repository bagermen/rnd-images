# rnd images

## Initiate Postgres environment
| OS  | Command |
| --- | ------- |
| Debian | <pre lang="powershell">devcontainer templates apply -t ghcr.io/bagermen/rnd-images/postgres-env -w .</pre>  |
| Ubuntu | <pre lang="powershell">devcontainer templates apply -t ghcr.io/bagermen/rnd-images/postgres-env -a '{"os": "-noble"}' -w .</pre>  |

https://docs.github.com/en/rest/actions/workflow-runs?apiVersion=2022-11-28#get-a-workflow-run
https://docs.github.com/en/rest/actions/workflow-runs?apiVersion=2022-11-28#list-workflow-runs-for-a-workflow
