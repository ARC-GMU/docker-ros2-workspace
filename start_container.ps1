docker run -d --rm `
    --user "$(wsl id -u):$(wsl id -g)" `
    --name arc-ros2 `
    -p 2222:22 `
    -v "${PWD}\workspace:/home/arc/workspace" `
    -e "DISPLAY=localhost:0" `
    -v /tmp/.X11-unix:/tmp/.X11-unix `
    arc-ros2:jazzy