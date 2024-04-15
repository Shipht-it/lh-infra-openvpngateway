# Use an official lightweight Alpine image as a parent image
FROM alpine:latest

# Install OpenVPN and easy-rsa for certificate management
RUN apk add --no-cache openvpn easy-rsa

# Set up easy-rsa directory to generate certs
RUN mkdir /etc/openvpn/easy-rsa && ln -s /usr/share/easy-rsa/* /etc/openvpn/easy-rsa
WORKDIR /etc/openvpn/easy-rsa
RUN ./easyrsa init-pki && \
    ./easyrsa build-ca nopass && \
    ./easyrsa gen-req server nopass && \
    ./easyrsa sign-req server ca

# Configuration files and server setup
COPY server.conf /etc/openvpn
COPY entrypoint.sh /entrypoint.sh

# Make entrypoint executable
RUN chmod +x /entrypoint.sh

# OpenVPN and management ports
EXPOSE 1194/udp
EXPOSE 943/tcp

ENTRYPOINT ["/entrypoint.sh"]
