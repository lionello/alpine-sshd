# alpine-sshd
This repository contains a `Dockerfile` to build a Docker image with an SSH
server. It's based on Alpine Linux and installs OpenSSH (`sshd`).

## User

The Dockerfile creates an unprivileged user account with no password and no
shell. The username can be set by providing the build-arg `USER` when building
the image. The default is `tunnel`.

## Public keys

The SSH server needs to be configured with host keys before it'll start. The
host public keys and the `authorized_keys` file can be written either during
the build or at runtime.

## Private keys

Adding the private host keys to the built image would be insecure, so this image
grabs the host keys from the environment at runtime. The host keys are then
written to the appropriate files before the SSH server is started.
