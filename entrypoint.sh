#!/bin/sh

# Enable IP forwarding
echo 1 > /proc/sys/net/ipv4/ip_forward

# Configure iptables rules for routing
iptables -t nat -A POSTROUTING -s 192.168.253.0/24 -o eth0 -j MASQUERADE
iptables -A FORWARD -i eth0 -o tun0 -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -A FORWARD -i tun0 -o eth0 -j ACCEPT

# Start the OpenVPN server
openvpn --config /etc/openvpn/server.conf