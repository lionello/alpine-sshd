# alpine-sshd

This repository contains a `Dockerfile` to build a Docker image with an SSH
server. It's based on Alpine Linux and installs OpenSSH (`sshd`).

A built image (w/o authorized keys) is pushed to Docker Hub at
[lionello/alpine-sshd](https://hub.docker.com/r/lionello/alpine-sshd).

## SSH User

The Dockerfile creates an unprivileged user account with no password and no
shell. The username can be set by providing the build-arg `USER` when building
the image. The default user is `tunnel`.

## Public keys

The SSH server needs to be configured with host keys before it'll start. The
host _public_ keys and the user's `authorized_keys` file can be written either during
the build or at runtime. At runtime, the env var `tunnel_authorized_keys` will be
written to `/home/tunnel/.ssh/authorized_keys`.

## Host Private keys

Adding _private_ keys to the built image would be insecure, so this image
grabs the _private_ host keys from the environment at runtime. The keys are then
written to the appropriate files before the SSH server is started, eg. the env
var `ssh_host_ed25519_key_pub` will be written to `/etc/ssh/ssh_host_ed25519_key.pub`.
