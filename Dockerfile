ARG ROS_DISTRO=humble

FROM ros:${ROS_DISTRO}-ros-base
ARG ROS_DISTRO
ARG USERNAME=rdc
ARG USER_UID=1000
ARG USER_GID=$USER_UID

# Delete user if it exists in container (e.g Ubuntu Noble: ubuntu)
RUN if id -u $USER_UID ; then userdel `id -un $USER_UID` ; fi

# Install dependencies
RUN apt-get -y update && \
    DEBIAN_FRONTEND=noninteractive apt-get -y install --no-install-recommends \
        curl \
        locales \
        nano \
        openssh-server \
        python3 \
        python3-colcon-common-extensions \
        python3-pip \
        python3-rosdep \
        python3-venv \
        software-properties-common \
        sudo && \
    rm -rf /var/lib/apt/lists/*

# Create the user
RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m -s /bin/bash $USERNAME \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME

# Set the locale
RUN locale-gen en_US.UTF-8 && \
    update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
ENV LANG=en_US.UTF-8

# Set up sshd working directory
RUN mkdir -p /var/run/sshd && \
    chmod 0755 /var/run/sshd && \
    ssh-keygen -A

# SSH hardening for container use
RUN sed -i 's/^#\?PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config && \
    sed -i 's/^#\?PasswordAuthentication.*/PasswordAuthentication yes/' /etc/ssh/sshd_config && \
    sed -i 's|^#\?AuthorizedKeysFile.*|AuthorizedKeysFile .ssh/authorized_keys|' /etc/ssh/sshd_config

# ********************************************************
# * Anything else you want to do like clean up goes here *
# ********************************************************
RUN echo "source /opt/ros/${ROS_DISTRO}/setup.bash" >> /home/$USERNAME/.bashrc \
    && echo "cd /home/$USERNAME/workspace" >> /home/$USERNAME/.bashrc
ENV SHELL=/bin/bash

# Create and own the ROS workspace before switching user
RUN mkdir -p /home/$USERNAME/workspace/src && \
    chown -R ${USERNAME}:${USERNAME} /home/$USERNAME/workspace && \
    chmod -R 0755 /home/$USERNAME/workspace

# Set a default password for SSH login (override via --build-arg USER_PASSWORD=...)
ARG USER_PASSWORD=rdc
RUN echo "${USERNAME}:${USER_PASSWORD}" | chpasswd

COPY docker/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# Set the default user. Omit if you want to keep the default as root.
USER $USERNAME

WORKDIR /home/$USERNAME/workspace

EXPOSE 22
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["sshd"]