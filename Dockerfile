FROM alpine:3
RUN apk add --no-cache openssh

# Create an unpriviliged user and set up their authorized_keys
ARG USER=tunnel
ENV USER=${USER}
# adduser -D creates a locked user, but we don't have usermod to unlock it, so replace pw ! with *
RUN adduser -D -s /bin/false ${USER} && \
    sed -i "s/^${USER}:!/${USER}:*/" /etc/shadow && \
    printf "Match User ${USER}\n\tAllowTcpForwarding yes\n" >> /etc/ssh/sshd_config

ARG authorized_keys
RUN mkdir -m700 /home/${USER}/.ssh && \
    umask 077 && \
    printf '%s\n' "${authorized_keys}" > /home/${USER}/.ssh/authorized_keys && \
    chown -R ${USER}:${USER} /home/${USER}/.ssh

# Grab the public host keys from the build args and write them to the correct locations
ARG ssh_host_ecdsa_key_pub
RUN printf '%s' "${ssh_host_ecdsa_key_pub}" > /etc/ssh/ssh_host_ecdsa_key.pub
ARG ssh_host_ed25519_key_pub
RUN printf '%s' "${ssh_host_ed25519_key_pub}" > /etc/ssh/ssh_host_ed25519_key.pub
ARG ssh_host_rsa_key_pub
RUN printf '%s' "${ssh_host_rsa_key_pub}" > /etc/ssh/ssh_host_rsa_key.pub

COPY write_ssh_host_keys.sh /root/
CMD ["/bin/sh", "-c", "/root/write_ssh_host_keys.sh && exec /usr/sbin/sshd -D -e"]
EXPOSE 22
