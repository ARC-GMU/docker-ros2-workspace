ARG ROS_DISTRO=jazzy

FROM osrf/ros:${ROS_DISTRO}-desktop-full
ARG ROS_DISTRO
ARG USERNAME=arc
ARG PASSWORD=123
ARG UID=1000
ARG GID=$UID

ENV DEBIAN_FRONTEND=noninteractive
SHELL ["/bin/bash", "-c"]

RUN apt-get update && apt-get install -y \
    openssh-server \
    sudo \
    && mkdir -p /run/sshd \
    && ssh-keygen -A \
    && rm -rf /var/lib/apt/lists/*

RUN if getent group ${GID} >/dev/null; then \
        groupmod -n ${USERNAME} $(getent group ${GID} | cut -d: -f1); \
    else \
        groupadd -g ${GID} ${USERNAME}; \
    fi && \
    if getent passwd ${UID} >/dev/null; then \
        usermod -l ${USERNAME} -m -d /home/${USERNAME} $(getent passwd ${UID} | cut -d: -f1); \
    else \
        useradd -m -u ${UID} -g ${GID} -s /bin/bash ${USERNAME}; \
    fi && \
    echo "${USERNAME}:${PASSWORD}" | chpasswd && \
    echo "${USERNAME} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

RUN sed -i 's/^#\?PasswordAuthentication.*/PasswordAuthentication yes/' /etc/ssh/sshd_config && \
    sed -i 's/^#\?PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config && \
    sed -i 's/^#\?ChallengeResponseAuthentication.*/ChallengeResponseAuthentication no/' /etc/ssh/sshd_config || true

RUN echo "source /opt/ros/${ROS_DISTRO}/setup.bash" >> /home/$USERNAME/.bashrc \
    && echo "cd /home/$USERNAME/workspace" >> /home/$USERNAME/.bashrc

RUN mkdir -p /home/$USERNAME/workspace/src && \
    chown -R ${USERNAME}:${USERNAME} /home/$USERNAME/workspace && \
    chmod -R 0755 /home/$USERNAME/workspace

EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]