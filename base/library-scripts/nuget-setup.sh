#!/usr/bin/env bash
set -e

USERNAME=${1:-"root"}

if [ "$(id -u)" -ne 0 ]; then
    echo -e 'Script must be run as root. Use sudo, su, or add "USER root" to your Dockerfile before running this script.'
    exit 1
fi

# Ensure that login shells get the correct path if the user updated the PATH using ENV.
rm -f /etc/profile.d/00-restore-env.sh
echo "export PATH=${PATH//$(sh -lc 'echo $PATH')/\$PATH}" > /etc/profile.d/00-restore-env.sh
chmod +x /etc/profile.d/00-restore-env.sh

group_name="$(id -gn $USERNAME)"

if [ "${USERNAME}" = "root" ]; then
    userhome="/root"
else
    userhome="/home/${USERNAME}"
fi

mkdir -p $userhome/.nuget/NuGet/config
echo '<?xml version="1.0" encoding="utf-8"?><configuration></configuration>' > $userhome/.nuget/NuGet/config/github.config
dotnet nuget add source \
	--username "%GITHUB_USERNAME%" \
	--password "%GITHUB_PASSWORD%" \
	--store-password-in-clear-text \
	--name github "https://nuget.pkg.github.com/%GITHUB_NAMESPACE%/index.json" \
	--configfile $userhome/.nuget/NuGet/config/github.config

cat > $userhome/.profile << EOF
# Add .NET Core SDK tools
if [ -d "\$HOME/.dotnet/tools" ] ; then
    PATH="\$HOME/.dotnet/tools:\$PATH"
fi
EOF

chown -R ${USERNAME}:${group_name} "${userhome}/.profile"
chown -R ${USERNAME}:${group_name} "${userhome}/.nuget/NuGet/config/github.config"
