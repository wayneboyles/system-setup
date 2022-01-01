#!/bin/bash

logInfo 'Configuring ntp servers...'

# Configure chrony
# TODO: For now this is hard coded.  Read the configuration
# from the yml file

apt-get install -y chrony > /dev/null 2>&1

systemctl enable chrony > /dev/null 2>&1
systemctl stop chrony > /dev/null 2>&1

# Remove the default debian section
sed -i "s/# Use Debian vendor zone.//" /etc/chrony/chrony.conf
sed -i "s/pool 2.debian.pool.ntp.org iburst//" /etc/chrony/chrony.conf

# Remove our NTP servers if they already exist
sed -i "s/pool 0.us.pool.ntp.org iburst//" /etc/chrony/chrony.conf
sed -i "s/pool 1.us.pool.ntp.org iburst//" /etc/chrony/chrony.conf

# Add the NTP servers
echo "pool 0.us.pool.ntp.org iburst" >> /etc/chrony/chrony.conf
echo "pool 1.us.pool.ntp.org iburst" >> /etc/chrony/chrony.conf

# Restart the service
systemctl restart chrony > /dev/null 2>&1