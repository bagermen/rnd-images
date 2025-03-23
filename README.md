# RND images

## Overview
devconainers to run RND projects

## Prerequisites
- @devcontainers/cli

## Getting the devcontainers

### Ubuntu based images

```powershell
devcontainer templates apply -t ghcr.io/bagermen/rnd-images/compose-template -a '{"os": "ubuntu"}'
```

### Debian based images

```powershell
devcontainer templates apply -t ghcr.io/bagermen/rnd-images/compose-template
```