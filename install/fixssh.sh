#!/bin/bash

# install openssh-server
apt-get install openssh-server

# remove current runlevels for SSH
update-rc.d -f ssh remove

# load default SSH runlevels
update-rc.d -f ssh defaults

# move old keys
mkdir /etc/ssh/insecure_original_keys
mv /etc/ssh/ssh_host_* insecure_original_keys

# create new keys
dpkg-reconfigure openssh-server
