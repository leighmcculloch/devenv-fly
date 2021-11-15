#!/usr/bin/env zsh

set -e

make -C $HOME/Code/flydev start
DOCKER_HOST=ssh://dev "$@"
img="$(DOCKER_HOST=ssh://dev docker images --format='{{.ID}}' | head -1)"
DOCKER_HOST=ssh://dev docker save "$img" | docker load
make -C $HOME/Code/flydev stop
