# ROS 2 Docker Workspace

This repository holds the ROS development environment for the Raytheon Drone Competition.
A ROS 2 Humble enviroment is preinstalled and sourced in this Docker image.

## Getting Started

### Required Software

Before you start, install the following programs on your computer:

 * (Windows) [WSL 2](https://learn.microsoft.com/en-us/windows/wsl/install)
 * [Docker Desktop](https://www.docker.com/products/docker-desktop/)

### Build Docker Image

From this directory, build the image (this will take some time):

```sh
docker build -t rdc-ros2 .
```

Run the image:

Linux/macOS:

```sh
./start_container.sh
```

Windows (PowerShell):

```pwsh
.\start_container.ps1
```
> [!NOTE]
> On Microsoft Windows, it may be required to enable the Activate.ps1 script by setting the execution policy for the user. You can do this by issuing the following PowerShell command:
> ```pwsh
> Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
> ```
> See [About Execution Policies](https://go.microsoft.com/fwlink/?LinkID=135170) for more information.

### Connect to Container

With the Docker image built, you you can connect to the development environment using SSH.

#### Connect via SSH

Open a terminal and enter
```sh
ssh rdc@localhost -p 2222
```

Connect and login using the password in the Dockerfile (default: `rdc`).
The ~/workspace/ directory is mapped from the host directory.
