ARG ROS_DISTRO=humble
FROM ros:${ROS_DISTRO}
ARG USERNAME=username
ARG USER_UID=1000
ARG USER_GID=$USER_UID

# Create the user
RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME \
    # [Optional] Add sudo support. Omit if you don't need to install software after connecting.
    && apt-get update \
    && apt-get install -y sudo \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME
RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y build-essential libgtk-3-dev python3-pip
ENV SHELL /bin/bash

RUN apt-get update && \
    apt-get install -y \
    wget \
    vim \
    tmux \
    bash-completion

RUN pip3 install pre-commit

RUN echo 'source /opt/ros/${ROS_DISTRO}/setup.bash' >> /home/$USERNAME/.bashrc
# [Optional] Set the default user. Omit if you want to keep the default as root.
USER $USERNAME
CMD ["/bin/bash"]