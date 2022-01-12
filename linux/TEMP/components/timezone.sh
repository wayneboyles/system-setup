#!/bin/bash

logInfo 'Setting the system timezone...'
timedatectl set-timezone $configure_system_timezone > /dev/null 2>&1