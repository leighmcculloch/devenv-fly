#!/usr/bin/env zsh

set -e

echo "Starting tailscale daemon..."
tailscaled --state=/var/lib/tailscale/tailscaled.state --socket=/var/run/tailscale/tailscaled.sock &
echo "Starting tailscale up..."
until tailscale up --hostname=dev --authkey=$TAILSCALE_AUTHKEY
do
    sleep 0.1
done

echo "Starting docker..."
mkdir -p /data/docker /etc/docker
echo '{"data-root": "/data/docker"}' > /etc/docker/daemon.json
service docker start

echo "Configuring inotify for VSCode..."
sysctl -w fs.inotify.max_user_watches=524288

echo "Setting up workspace directory..."
mkdir -p /data/workspace

echo "Linking any persistent files and directories..."
ln -s /data/zsh_history /root/.zsh_history
ln -s /data/workspace /root/workspace

echo "Starting sshd..."
service ssh start

trap : TERM INT
sleep infinity & wait

echo "Exiting..."
