#!/bin/bash

RED="\033[01;31m"      # Issues/Errors
GREEN="\033[01;32m"    # Success
YELLOW="\033[01;33m"   # Warnings/Information
BLUE="\033[01;34m"     # Heading
BOLD="\033[01;01m"     # Highlight
RESET="\033[00m"       # Normal

clear

BANNER="\n${BOLD}[!] ${RED}[RAMAKANDRA INFORMATION SECURITY]${RESET}"
for i in {1}
do
  echo -e $BANNER
done

# update apt-get
echo -e "\n${GREEN}[+]${RESET} Updating ${GREEN}apt-get${RESET}"
apt-get update

# upgrade packages
echo -e "\n${GREEN}[+]${RESET} Upgrading ${GREEN}packages${RESET}"
apt-get upgrade -y

# upgrade os
echo -e "\n${GREEN}[+]${RESET} Updating ${GREEN}system${RESET}"
apt-get dist-upgrade -y

# cleanup
echo -e "\n${GREEN}[+]${RESET} Performing ${GREEN}cleanup${RESET}"
apt-get autoremove -y
