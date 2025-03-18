#!/usr/bin/env bash
#
# Docs: https://github.com/microsoft/vscode-dev-containers/blob/main/script-library/docs/common.md
# Upgrade/Add packages
# Syntax: ./packages.sh [upgrade packages flag] [packages list]

set -e

NVM_DIR=${1:-"/usr/local/share/nvm"}
SERVICE_NAME=${2:-"rnd"}
USERNAME=${1:-"root"}
SITE_PATH=${2:-"/var/www/rnd"}

if [ "$(id -u)" -ne 0 ]; then
    echo -e 'Script must be run as root. Use sudo, su, or add "USER root" to your Dockerfile before running this script.'
    exit 1
fi

# Ensure that login shells get the correct path if the user updated the PATH using ENV.
rm -f /etc/profile.d/00-restore-env.sh
echo "export PATH=${PATH//$(sh -lc 'echo $PATH')/\$PATH}" > /etc/profile.d/00-restore-env.sh
chmod +x /etc/profile.d/00-restore-env.sh

if [ "${USERNAME}" = "root" ]; then
    userhome="/root"
else
    userhome="/home/${USERNAME}"
fi

path_to_replace="\$SITEPATH"
escaped_path_to_replace=$(printf '%s\n' "$path_to_replace" | sed -e 's/[]\/$*.^[]/\\&/g')
escaped_path=$(printf '%s\n' "$SITE_PATH" | sed -e 's/[]\/$*.^[]/\\&/g')
sed -i -E "s/$escaped_path_to_replace/$escaped_path/" "/etc/systemd/system/$SERVICE_NAME.service"

userhome_to_replace="\$USERHOME"
escaped_userhome_to_replace=$(printf '%s\n' "$userhome_to_replace" | sed -e 's/[]\/$*.^[]/\\&/g')
escaped_userhome=$(printf '%s\n' "$userhome" | sed -e 's/[]\/$*.^[]/\\&/g')
sed -i -E "s/$escaped_userhome_to_replace/$escaped_userhome/" "/etc/systemd/system/$SERVICE_NAME.service"

username_to_replace="\$USERNAME"
escaped_username_to_replace=$(printf '%s\n' "$username_to_replace" | sed -e 's/[]\/$*.^[]/\\&/g')
escaped_username=$(printf '%s\n' "$USERNAME" | sed -e 's/[]\/$*.^[]/\\&/g')
sed -i -E "s/$escaped_username_to_replace/$escaped_username/" "/etc/systemd/system/$SERVICE_NAME.service"

replace=$(echo $NVM_DIR)
escaped_replace=$(printf '%s\n' "$replace" | sed -e 's/[]\/$*.^[]/\\&/g')
path_to_replace="\$NVM_DIR"
escaped_path_to_replace=$(printf '%s\n' "$path_to_replace" | sed -e 's/[]\/$*.^[]/\\&/g')
sed -i -E "s/$escaped_path_to_replace/$escaped_replace/" "/etc/systemd/system/$SERVICE_NAME.service"

node_version=$(echo $(node -v))
escaped_node_version=$(printf '%s\n' "$node_version" | sed -e 's/[]\/$*.^[]/\\&/g')
path_to_replace_node_version="\$NODE_VERSION"
escaped_path_to_replace_node_version=$(printf '%s\n' "$path_to_replace_node_version" | sed -e 's/[]\/$*.^[]/\\&/g')
sed -i -E "s/$escaped_path_to_replace_node_version/$escaped_node_version/" "/etc/systemd/system/$SERVICE_NAME.service"

# /bin/systemctl enable $SERVICE_NAME

echo "Done!"
