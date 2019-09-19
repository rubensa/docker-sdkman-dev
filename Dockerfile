FROM rubensa/ubuntu-dev
LABEL author="Ruben Suarez <rubensa@gmail.com>"

# Define sdkman group id's
ARG SDKMAN_GROUP_ID=2000

# Define sdkman group and installation folder
ENV SDKMAN_GROUP=sdkman SDKMAN_INSTALL_DIR=/opt/sdkman

# Add sdkman binary to PATH
ENV PATH="${SDKMAN_INSTALL_DIR}/bin:$PATH"

# Tell docker that all future commands should be run as root
USER root

# Set root home directory
ENV HOME=/root

# Avoid warnings by switching to noninteractive
ENV DEBIAN_FRONTEND=noninteractive

# Configure apt and install packages
RUN apt-get update \
    # 
    # Install ACL
    && apt-get -y install acl \
    # 
    # Install zip
    && apt-get -y install zip unzip \
    #
    # Create sdkman group
    && addgroup --gid ${SDKMAN_GROUP_ID} ${SDKMAN_GROUP} \
    #
    # Assign sdkman group to non-root user
    && usermod -a -G ${SDKMAN_GROUP} ${DEV_USER} \
    #
    # Install sdkman
    && export SDKMAN_DIR=${SDKMAN_INSTALL_DIR} \
    && curl -s "https://get.sdkman.io" | /bin/bash \
    #
    # Assign sdkman group folder ownership
    && chgrp -R ${SDKMAN_GROUP} ${SDKMAN_INSTALL_DIR} \
    #
    # Set the segid bit to the folder
    && chmod -R g+s ${SDKMAN_INSTALL_DIR} \
    #
    # Give write acces to the group
    && chmod -R g+wX ${SDKMAN_INSTALL_DIR} \
    #
    # Set ACL to files created in the folder
    && setfacl -d -m u::rwX,g::rwX,o::r-X ${SDKMAN_INSTALL_DIR} \
    #
    # Clean up
    && apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*

# Switch back to dialog for any ad-hoc use of apt-get
ENV DEBIAN_FRONTEND=

# Tell docker that all future commands should be run as the non-root user
USER ${DEV_USER}

# Set user home directory (see: https://github.com/microsoft/vscode-remote-release/issues/852)
ENV HOME /home/$DEV_USER

# Configure conda for the non-root user
RUN printf "\nexport SDKMAN_DIR=${SDKMAN_INSTALL_DIR}\n. ${SDKMAN_INSTALL_DIR}/bin/sdkman-init.sh\n" >> ~/.bashrc
