#!/bin/bash

if [[ $configure_system_root_login == 'yes' ]]; then
  logInfo "Enabling root login via ssh..."

  sed -i "s|PermitRootLogin prohibit-password\+|PermitRootLogin yes|g" /etc/ssh/sshd_config
  sed -i "s|PermitRootLogin without-password\+|PermitRootLogin yes|g" /etc/ssh/sshd_config
  sed -i "s|PermitRootLogin no\+|PermitRootLogin yes|g" /etc/ssh/sshd_config
  sed -i "s|#PermitRootLogin\+|PermitRootLogin|g" /etc/ssh/sshd_config

  systemctl restart sshd > /dev/null 2>&1
fi