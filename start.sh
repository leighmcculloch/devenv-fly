#!/usr/bin/env zsh

set -e

echo "Starting tailscale daemon..."
tailscaled --state=/var/lib/tailscale/tailscaled.state --socket=/var/run/tailscale/tailscaled.sock &
echo "Starting tailscale up..."
until tailscale up --hostname=flydev
do
    sleep 0.1
done

echo "Starting docker..."
mkdir -p /data/docker /etc/docker
echo '{"data-root": "/data/docker", "ipv6": true, "fixed-cidr-v6": "2001:db8:1::/64"}' > /etc/docker/daemon.json
service docker start
sleep 2
ip -6 route add 2001:db8:1::/64 dev docker0
sysctl net.ipv6.conf.default.forwarding=1
sysctl net.ipv6.conf.all.forwarding=1
ip6tables -t nat -A POSTROUTING -s 2001:db8:1::/64 -j MASQUERADE

echo "Configuring inotify for VSCode..."
sysctl -w fs.inotify.max_user_watches=524288

echo "Starting sshd..."
/usr/sbin/sshd -D

echo "Exiting..."
