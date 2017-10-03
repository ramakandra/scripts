#!/bin/bash

# update apt-get
apt-get update

# SHELL TOOLS
# install or update tmux
apt-get install tmux

# install or update dnsrecon
apt-get install dnsrecon

# install or update nmap
apt-get install nmap

# install or update amap
apt-get install amap

# install etherape
apt-get install etherape

# install or update netdiscover
apt-get install netdiscover

# install or update nikto 
apt-get install nikto

# install or update whatweb
apt-get install whatweb

# install or update wpscan (wordpress vulnscanner)
apt-get install wpscan

# install or update ccrypt (command line encrypter)
apt-get install ccrypt

# install or update ccze (required for colortail)
apt-get install ccze

# install or update ranger
apt-get install ranger

# install or update midnight commander
apt-get install mc

# SET ALIASES
# always run mc with the -x switch for mouse support in tmux
echo "alias mc='mc -x'" >> ~/.bashrc

# install, update and set  colorful man pages
apt-get install most && update-alternatives --set pager /usr/bin/most

# super update and cleanup
echo "alias supdate='apt-get update && apt-get upgrade -y && apt-get dist-upgrade -y && apt-get autoremove'" >> ~/.bashrc

# always run ccrypt verbose and prevent typos
echo "alias crypt='ccrypt -v'" >> ~/.bashrc

# set nano as default editor
echo "set EDITOR='nano'"  >> ~/.bashrc
echo "$EDITOR" >> ~/.bashrc

# set directory colors from .dircolorsrc
echo "eval '`dircolors -b ~/.dircolorsrc`'" >> ~/.bashrc

# show all current internet connections of running processes
echo "alias internet='lsof -P -i -n'" >> ~/.bashrc

# colorful tailing of logfiles
echo "alias colortail='tail -f /var/log/syslog | ccze -A'" >> ~/.bashrc

# show mounts in pretty columns 
echo "alias mount='mount | column -t'" >> ~/.bashrc

# show my ip
echo "alias myip='curl ifconfig.me'" >> ~/.bashrc

