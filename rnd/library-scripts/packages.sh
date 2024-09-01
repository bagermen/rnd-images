#!/usr/bin/env bash
#
# Docs: https://github.com/microsoft/vscode-dev-containers/blob/main/script-library/docs/common.md
# Upgrade/Add packages 
# Syntax: ./packages.sh [upgrade packages flag] [packages list] 

set -e

UPGRADE_PACKAGES=${1:-"true"}
PACKAGES=${2:-""}
MARKER_FILE="/usr/local/etc/vscode-dev-containers/common"

if [ "$(id -u)" -ne 0 ]; then
    echo -e 'Script must be run as root. Use sudo, su, or add "USER root" to your Dockerfile before running this script.'
    exit 1
fi

# Ensure that login shells get the correct path if the user updated the PATH using ENV.
rm -f /etc/profile.d/00-restore-env.sh
echo "export PATH=${PATH//$(sh -lc 'echo $PATH')/\$PATH}" > /etc/profile.d/00-restore-env.sh
chmod +x /etc/profile.d/00-restore-env.sh

# Load markers to see which steps have already run
if [ -f "${MARKER_FILE}" ]; then
    echo "Marker file found:"
    cat "${MARKER_FILE}"
    source "${MARKER_FILE}"
fi

# Ensure apt is in non-interactive to avoid prompts
export DEBIAN_FRONTEND=noninteractive

# Function to call apt-get if needed
apt_get_update_if_needed()
{
    if [ ! -d "/var/lib/apt/lists" ] || [ "$(ls /var/lib/apt/lists/ | wc -l)" = "0" ]; then
        echo "Running apt-get update..."
        apt-get update
    else
        echo "Skipping apt-get update."
    fi
}

package_list="apt-utils \
    locales \
    sudo"

if [ -n "${PACKAGES}"]; then
    package_list="${package_list} ${PACKAGES}"
fi

apt_get_update_if_needed
echo "Packages to verify are installed: ${package_list}"
apt-get -y install --no-install-recommends ${package_list} 2> >( grep -v 'debconf: delaying package configuration, since apt-utils is not installed' >&2 )

# Get to latest versions of all packages
if [ "${UPGRADE_PACKAGES}" = "true" ]; then
    apt_get_update_if_needed
    apt-get -y upgrade --no-install-recommends
    apt-get autoremove -y
fi

# Ensure at least the en_US.UTF-8 UTF-8 locale is available.
if [ "${LOCALE_ALREADY_SET}" != "true" ] && ! grep -o -E '^\s*en_US.UTF-8\s+UTF-8' /etc/locale.gen > /dev/null; then
    echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen 
    locale-gen
    LOCALE_ALREADY_SET="true"
fi

# Write marker file
mkdir -p "$(dirname "${MARKER_FILE}")"
echo -e "LOCALE_ALREADY_SET=${LOCALE_ALREADY_SET}" > "${MARKER_FILE}"

echo "Done!"
