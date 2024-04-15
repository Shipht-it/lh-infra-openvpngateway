#!/bin/sh

# Generate OpenVPN server certificates (if not already generated)
if [ ! -f /etc/openvpn/ca.crt ] || [ ! -f /etc/openvpn/server.crt ] || [ ! -f /etc/openvpn/server.key ] || [ ! -f /etc/openvpn/dh.pem ]; then
    cd /etc/openvpn
    openssl dhparam -out dh.pem 2048
    openssl req -new -newkey rsa:2048 -days 3650 -nodes -x509 -keyout server.key -out server.crt -subj "/CN=OpenVPN Server"
    openssl req -new -newkey rsa:2048 -days 3650 -nodes -x509 -keyout ca.key -out ca.crt -subj "/CN=OpenVPN CA"
fi

# Enable IP forwarding
echo 1 > /proc/sys/net/ipv4/ip_forward

# Configure iptables rules for routing
iptables -t nat -A POSTROUTING -s 10.8.0.0/24 -o eth0 -j MASQUERADE
iptables -A FORWARD -i eth0 -o tun0 -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -A FORWARD -i tun0 -o eth0 -j ACCEPT

# Start the OpenVPN server
openvpn --config /etc/openvpn/server.conf