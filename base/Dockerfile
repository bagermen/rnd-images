ARG VARIANT=3.1
# ARG VARIANT=3.1-focal (ubuntu 20)
# ARG VARIANT=3.1 (debian 10)
FROM mcr.microsoft.com/dotnet/sdk:${VARIANT}

# Copy library scripts to execute (some fake changes 21)
COPY library-scripts/*.sh library-scripts/*.env /tmp/library-scripts/

# [Option] Upgrade OS packages to their latest versions
ARG UPGRADE_PACKAGES="true"

ARG USERNAME=dotnetuser
ARG USER_PASSW="skip"
ARG USER_UID=1000
ARG USER_GID=$USER_UID


# Install needed packages and setup non-root user. Use a separate RUN statement to add your own dependencies.
RUN bash /tmp/library-scripts/packages.sh "${UPGRADE_PACKAGES}" "libgdiplus"  \
    && bash /tmp/library-scripts/user.sh "${USERNAME}" "${USER_UID}" "${USER_GID}" \
    && apt-get clean -y && rm -rf /var/lib/apt/lists/*

# Install node

ARG NODE_VERSION="14"
ARG NVM_DIR=/usr/local/share/nvm
ENV NVM_SYMLINK_CURRENT=true \
    PATH=${NVM_DIR}/current/bin:${PATH}
RUN bash /tmp/library-scripts/node.sh "/usr/local/share/nvm" "${NODE_VERSION}" "${USERNAME}" "true" "false" \
    && apt-get clean -y && rm -rf /var/lib/apt/lists/*

# Install SSHD
ARG ADD_SSH="false"
ARG SSHD_PORT=22
EXPOSE $SSHD_PORT

RUN bash /tmp/library-scripts/sshd.sh "${ADD_SSH}" "${SSHD_PORT}" "${USERNAME}" "false" "${USER_PASSW}" \
    && apt-get clean -y && rm -rf /var/lib/apt/lists/*

# Add systemctl script
COPY library-scripts/systemctl.py /usr/local/share

RUN mkdir -p /run/systemd/system \
    && chmod +x /usr/local/share/systemctl.py \
    && ln -s /usr/local/share/systemctl.py /bin/systemctl

# add bpmsoft service and actualize node
COPY library-scripts/bpmsoft.service /etc/systemd/system
RUN bash /tmp/library-scripts/service-setup.sh "${NVM_DIR}" "bpmsoft"  \
    && mkdir /etc/bpmsoft \
    && chown -R $USER_UID:$USER_GID /etc/bpmsoft

VOLUME [ "/etc/bpmsoft" ]

# Remove library scripts for final image
RUN rm -rf /tmp/library-scripts

# start in container script or make it a default command
# CMD ["/bin/systemctl", "default"]

# leave it
# [Optional] Uncomment this section to install additional OS packages.
# RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
#     && apt-get -y install --no-install-recommends <your-package-list-here>

# [Optional] Uncomment this line to install global node packages.
# RUN su vscode -c "source /usr/local/share/nvm/nvm.sh && npm install -g <your-package-here>" 2>&1
