FROM alpine:3
RUN apk add --no-cache openssh
ARG USER=alpine
# adduser -D creates a locked user, but we don't have usermod to unlock it, so replace pw ! with *
RUN adduser -D ${USER} && \
    sed -i "s/^${USER}:!/${USER}:*/" /etc/shadow
COPY authorized_keys /home/${USER}/.ssh/
# Kaniko doesn't support COPY --chmod yet, so we have to do this:
RUN chown -R ${USER}:${USER} /home/${USER}/.ssh && \
    chmod 700 /home/${USER}/.ssh && \
    chmod 600 /home/${USER}/.ssh/authorized_keys
# TODO: grab these from env at container start
COPY ssh_host_* /etc/ssh/
ENTRYPOINT [ "/usr/sbin/sshd" ]
CMD ["-D", "-e"]
EXPOSE 22
