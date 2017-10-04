#!/bin/bash

RED="\033[01;31m"      # Issues/Errors
GREEN="\033[01;32m"    # Success
YELLOW="\033[01;33m"   # Warnings/Information
BLUE="\033[01;34m"     # Heading
BOLD="\033[01;01m"     # Highlight
RESET="\033[00m"       # Normal

BANNER="\n${BOLD}[!] ${RED}[RAMAKANDRA INFORMATION SECURITY]${RESET}"
for i in {1}
do
  echo -e $BANNER
done
echo -e "\n${YELLOW}[!]${RESET} The installation will start in 5 seconds"

sleep 5

# update apt-get
echo -e "\n${GREEN}[+]${RESET} Updating ${GREEN}apt-get${RESET}"
apt-get update

# upgrade packages
echo -e "\n${GREEN}[+]${RESET} Upgrading ${GREEN}packages${RESET}"
apt-get upgrade -y

# upgrade os
echo -e "\n${GREEN}[+]${RESET} Updating ${GREEN}system${RESET}"
apt-get dist-upgrade -y

# update apt-get
echo -e "\n${GREEN}[+]${RESET} Performing ${GREEN}cleanup${RESET}"
apt-get autoremove

# SHELL TOOLS
echo -e "\n${GREEN}[+]${RESET} Installing ${GREEN}shell tools${RESET}"

# install or update tmux
echo -e "\n${GREEN}[+]${RESET} Install or update ${GREEN}tmux${RESET}"
apt-get install tmux

# install or update dnsrecon
echo -e "\n${GREEN}[+]${RESET} Install or update ${GREEN}dnsrecon${RESET}"
apt-get install dnsrecon

# install or update nmap
echo -e "\n${GREEN}[+]${RESET} Install or update ${GREEN}nmap${RESET}"
apt-get install nmap

# install or update amap
echo -e "\n${GREEN}[+]${RESET} Install or update ${GREEN}amap${RESET}"
apt-get install amap

# install etherape
echo -e "\n${GREEN}[+]${RESET} Install or update ${GREEN}etherape${RESET}"
apt-get install etherape

# install or update netdiscover
echo -e "\n${GREEN}[+]${RESET} Install or update ${GREEN}netdiscover${RESET}"
apt-get install netdiscover

# install or update nikto 
echo -e "\n${GREEN}[+]${RESET} Install or update ${GREEN}nikto${RESET}"
apt-get install nikto

# install or update whatweb
echo -e "\n${GREEN}[+]${RESET} Install or update ${GREEN}whatweb${RESET}"
apt-get install whatweb

# install or update wpscan
echo -e "\n${GREEN}[+]${RESET} Install or update ${GREEN}wpscan${RESET}"
apt-get install wpscan

# install or update ccrypt
echo -e "\n${GREEN}[+]${RESET} Install or update ${GREEN}ccrypt${RESET}"
apt-get install ccrypt

# install or update ccze (required for colortail)
echo -e "\n${GREEN}[+]${RESET} Install or update ${GREEN}ccze${RESET}"
apt-get install ccze

# install or update ranger
echo -e "\n${GREEN}[+]${RESET} Install or update ${GREEN}ranger${RESET}"
apt-get install ranger

# install or update midnight commander
echo -e "\n${GREEN}[+]${RESET} Install or update ${GREEN}midnight commander${RESET}"
apt-get install mc

# install or update GIT
echo -e "\n${GREEN}[+]${RESET} Install or update ${GREEN}git${RESET}"
apt-get install git

# install or clone commix
echo -e "\n${GREEN}[+]${RESET} Install or update ${GREEN}commix${RESET}"
apt-get install commix

# install exiftool
echo -e "\n${GREEN}[+]${RESET} Installing ${GREEN}exiftool${RESET}"
wget http://www.sno.phy.queensu.ca/~phil/exiftool/Image-ExifTool-10.53.tar.gz
gzip -dc Image-ExifTool-10.53.tar.gz | tar -xf -
rm Image-ExifTool-10.53.tar.gz
cd Image-ExifTool-10.53
perl Makefile.PL
make test
make install


# SET ALIASES
echo -e "\n${GREEN}[+]${RESET} Set alisases ${GREEN}and write to .bashrc${RESET}"

# always run mc with the -x switch for mouse support in tmux
echo -e "\n${GREEN}[+]${RESET} always run mc with the -x switch for mouse support in tmux"
echo "alias mc='mc -x'" >> ~/.bashrc

# install, update and set  colorful man pages
echo -e "\n${GREEN}[+]${RESET} install, update and set  colorful man pages"
apt-get install most && update-alternatives --set pager /usr/bin/most

# super update and cleanup
echo -e "\n${GREEN}[+]${RESET} super update and cleanup"
echo "alias supdate='apt-get update && apt-get upgrade -y && apt-get dist-upgrade -y && apt-get autoremove'" >> ~/.bashrc

# always run ccrypt verbose and prevent typos
echo -e "\n${GREEN}[+]${RESET} always run ccrypt verbose and prevent typos"
echo "alias crypt='ccrypt -v'" >> ~/.bashrc

# set nano as default editor
echo -e "\n${GREEN}[+]${RESET} set nano as default editor"
echo "set EDITOR='nano'"  >> ~/.bashrc
echo "$EDITOR" >> ~/.bashrc

# show all current internet connections of running processes
echo -e "\n${GREEN}[+]${RESET} show all current internet connections of running processes"
echo "alias internet='lsof -P -i -n'" >> ~/.bashrc

# colorful tailing of logfiles
echo -e "\n${GREEN}[+]${RESET} colorful tailing of logfiles"
echo "alias colortail='tail -f /var/log/syslog | ccze -A'" >> ~/.bashrc

# show mounts in pretty columns 
echo -e "\n${GREEN}[+]${RESET} show mounts in pretty columns"
echo "alias mount='mount | column -t'" >> ~/.bashrc

# show my ip
echo -e "\n${GREEN}[+]${RESET} show my ip"
echo "alias myip='curl ifconfig.me'" >> ~/.bashrc
