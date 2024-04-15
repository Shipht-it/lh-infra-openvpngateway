# Use the Alpine Linux base image
FROM alpine:latest

# Install OpenVPN and the OpenVPN Azure AD Authentication Plugin
RUN apk add --no-cache openvpn openvpn-auth-azure-ad

# Copy the OpenVPN server configuration file to the container
COPY server.conf /etc/openvpn

# Copy the entrypoint script to the container
COPY entrypoint.sh /entrypoint.sh

# Make the entrypoint script executable
RUN chmod +x /entrypoint.sh

# Expose the OpenVPN port (1194/UDP) and SSH port (22/TCP)
EXPOSE 1194/udp
EXPOSE 22/tcp

# Set the entrypoint script as the container's entrypoint
ENTRYPOINT ["/entrypoint.sh"]