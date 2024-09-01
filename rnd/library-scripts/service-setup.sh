#!/usr/bin/env bash
#
# Docs: https://github.com/microsoft/vscode-dev-containers/blob/main/script-library/docs/common.md
# Upgrade/Add packages 
# Syntax: ./packages.sh [upgrade packages flag] [packages list] 

set -e

NVM_DIR=${1:-"/usr/local/share/nvm"}
SERVICE_NAME=${2:-"bpmsoft"}

if [ "$(id -u)" -ne 0 ]; then
    echo -e 'Script must be run as root. Use sudo, su, or add "USER root" to your Dockerfile before running this script.'
    exit 1
fi

# Ensure that login shells get the correct path if the user updated the PATH using ENV.
rm -f /etc/profile.d/00-restore-env.sh
echo "export PATH=${PATH//$(sh -lc 'echo $PATH')/\$PATH}" > /etc/profile.d/00-restore-env.sh
chmod +x /etc/profile.d/00-restore-env.sh

REPLACE=$(echo $NVM_DIR)
ESCAPED_REPLACE=$(printf '%s\n' "$REPLACE" | sed -e 's/[]\/$*.^[]/\\&/g')
PATH_TO_REPLACE="\$NVM_DIR"
ESCAPED_PATH_TO_REPLACE=$(printf '%s\n' "$PATH_TO_REPLACE" | sed -e 's/[]\/$*.^[]/\\&/g')
sed -i -E "s/$ESCAPED_PATH_TO_REPLACE/$ESCAPED_REPLACE/" "/etc/systemd/system/$SERVICE_NAME.service"

NODE_VERSION=$(echo $(node -v))
ESCAPED_NODE_VERSION=$(printf '%s\n' "$NODE_VERSION" | sed -e 's/[]\/$*.^[]/\\&/g')
PATH_TO_REPLACE_NODE_VERSION="\$NODE_VERSION"
ESCAPED_PATH_TO_REPLACE_NODE_VERSION=$(printf '%s\n' "$PATH_TO_REPLACE_NODE_VERSION" | sed -e 's/[]\/$*.^[]/\\&/g')
sed -i -E "s/$ESCAPED_PATH_TO_REPLACE_NODE_VERSION/$ESCAPED_NODE_VERSION/" "/etc/systemd/system/$SERVICE_NAME.service"

/bin/systemctl enable $SERVICE_NAME

echo "Done!"