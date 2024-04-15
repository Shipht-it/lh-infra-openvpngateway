# Use the Alpine Linux base image
FROM alpine:latest

# Install OpenVPN and its dependencies
RUN apk add --no-cache openvpn openssl

# Install required build tools and dependencies
RUN apk add --no-cache --virtual .build-deps wget ca-certificates make go

# Download and build the openvpn-auth-oauth2 plugin
RUN wget https://github.com/jkroepke/openvpn-auth-oauth2/archive/refs/tags/v1.0.0.tar.gz && \
    tar -xzf v1.0.0.tar.gz && \
    cd openvpn-auth-oauth2-1.0.0 && \
    make build && \
    mv openvpn-auth-oauth2 /usr/bin/ && \
    cd .. && \
    rm -rf openvpn-auth-oauth2-1.0.0 v1.0.0.tar.gz

# Clean up build dependencies
RUN apk del .build-deps

# Copy the OpenVPN server configuration file to the container
COPY server.conf /etc/openvpn/

# Copy the openvpn-auth-oauth2 configuration file to the container
COPY oauth.cfg /etc/openvpn/

# Copy the entrypoint script to the container
COPY entrypoint.sh /entrypoint.sh

# Make the entrypoint script executable
RUN chmod +x /entrypoint.sh

# Expose the OpenVPN port (1194/UDP) and SSH port (22/TCP)
EXPOSE 1194/udp
EXPOSE 22/tcp

# Set the entrypoint script as the container's entrypoint
ENTRYPOINT ["/entrypoint.sh"]