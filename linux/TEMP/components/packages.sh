#!/bin/bash

if [[ $configure_packages ]]; then
  logInfo "Installing packages..."
  apt-get install -y $configure_packages > /dev/null 2>&1
fi