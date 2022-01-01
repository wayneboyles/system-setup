#!/bin/bash

logInfo "Installing system fonts..."

cd /tmp && git clone https://github.com/powerline/fonts.git --depth=1 -q > /dev/null 2>&1

/tmp/fonts/install.sh > /dev/null 2>&1

rm -rf /tmp/fonts