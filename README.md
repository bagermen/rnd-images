# RND images

## Overview
devconainers to run RND projects

## Prerequisites
- devcontainer

## Getting the devcontainers

### Ubuntu based images

```powershell
devcontainer templates apply -t ghcr.io/bagermen/rnd-images/compose-template -a '{"os": "-noble"}'
```

### Debian based images

```powershell
devcontainer templates apply -t ghcr.io/bagermen/rnd-images/compose-template
```