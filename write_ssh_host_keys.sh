#!/bin/sh
umask 077
env -0 | while IFS='=' read -r -d '' n v; do
  if [[ $n == ssh_host_* ]]; then
    n=/etc/ssh/${n/_pub/.pub} # replace _pub with .pub
  elif [[ $n == *_authorized_keys ]]; then
    n=/home/${n/_authorized_keys/\/.ssh\/authorized_keys} # prefix is username
  else
    continue
  fi
  echo Writing $n
  printf '%s\n' "$v" >> $n
done
