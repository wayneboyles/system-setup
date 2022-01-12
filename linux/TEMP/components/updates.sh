#!/bin/bash

if [[ $configure_update == 'yes' ]]; then
  logInfo 'Running system updates...'
  apt-get update -y > /dev/null 2>&1
  apt-get clean all > /dev/null 2>&1
fi