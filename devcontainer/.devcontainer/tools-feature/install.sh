#!/usr/bin/env bash
RND_TOOL_VERSION=${VERSION}

if [ "$(id -u)" -ne 0 ]; then
    echo -e 'Script must be run as root. Use sudo, su, or add "USER root" to your Dockerfile before running this script.'
    exit 1
fi

dotnet tool install --global RND.Tools.CmdLine --add-source github --version $RND_TOOL_VERSION
