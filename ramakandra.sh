#!/bin/bash 

# Colors
ESC="\e["
RESET=$ESC"39m"
RED=$ESC"31m"
GREEN=$ESC"32m"
BLUE=$ESC"34m"

clear

function banner {

echo "                               __                   __          "
echo "   _________ _____ ___  ____ _/ /______ _____  ____/ /________ _" 
echo "  / ___/ __  / __  __ \/ __  / //_/ __  / __ \/ __  / ___/ __  /"
echo " / /  / /_/ / / / / / / /_/ / ,< / /_/ / / / / /_/ / /  / /_/ / "
echo "/_/   \__,_/_/ /_/ /_/\__,_/_/|_|\__,_/_/ /_/\__,_/_/   \__,_/  "
echo "                                                                "
echo ""

}

function usage {
    echo "Usage: $0 -t targets.txt [-p tcp/udp/all] [-i interface] [-n nmap-options] [-h]"
    echo "       -h: Help"
    echo "       -t: File containing ip addresses to scan. This option is required."
    echo "       -p: Protocol. Defaults to tcp"
    echo "       -i: Network interface. Defaults to eth0"
    echo "       -n: NMAP options (-A, -O, etc). Defaults to no options."
}


banner

if [[ ! $(id -u) == 0 ]]; then
    echo -e "${RED}[!]${RESET} This script must be run as root"
    exit 1
fi

if [[ -z $(which nmap) ]]; then
    echo -e "${RED}[!]${RESET} Unable to find nmap. Install it and make sure it's in your PATH environment"
    exit 1
fi

if [[ -z $(which unicornscan) ]]; then
    echo -e "${RED}[!]${RESET} Unable to find unicornscan. Install it and make sure it's in your PATH environment"
    exit 1
fi

if [[ -z $1 ]]; then
    usage
    exit 0
fi

# commonly used default options
proto="tcp"
iface="eth0"
nmap_opt="-sV"
targets="targets"

while getopts "p:i:t:n:h" OPT; do
    case $OPT in
        p) proto=${OPTARG};;
        i) iface=${OPTARG};;
        t) targets=${OPTARG};;
        n) nmap_opt=${OPTARG};;
        h) usage; exit 0;;
        *) usage; exit 0;;
    esac
done

if [[ -z $targets ]]; then
    echo "[!] No target file provided"
    usage
    exit 1
fi

if [[ ${proto} != "tcp" && ${proto} != "udp" && ${proto} != "all" ]]; then
    echo "[!] Unsupported protocol"
    usage
    exit 1
fi

echo -e "${GREEN}[+]${RESET} Protocol : ${proto}"
echo -e "${GREEN}[+]${RESET} Interface: ${iface}"
echo -e "${GREEN}[+]${RESET} Nmap opts: ${nmap_opt}"
echo -e "${GREEN}[+]${RESET} Targets  : ${targets}"

# backup any old scans before we start a new one
log_dir="${HOME}/.onetwopunch"
mkdir -p "${log_dir}/backup/"
if [[ -d "${log_dir}/ndir/" ]]; then 
    mv "${log_dir}/ndir/" "${log_dir}/backup/ndir-$(date "+%Y%m%d-%H%M%S")/"
fi
if [[ -d "${log_dir}/udir/" ]]; then 
    mv "${log_dir}/udir/" "${log_dir}/backup/udir-$(date "+%Y%m%d-%H%M%S")/"
fi 

rm -rf "${log_dir}/ndir/"
mkdir -p "${log_dir}/ndir/"
rm -rf "${log_dir}/udir/"
mkdir -p "${log_dir}/udir/"

while read ip; do
    echo ""
    echo -e "${GREEN}[+]${RESET} Scanning $ip for $proto ports..."

    # unicornscan identifies all open TCP ports
    if [[ $proto == "tcp" || $proto == "all" ]]; then 
        echo -e "${GREEN}[+]${RESET} Obtaining all open TCP ports using unicornscan..."
        echo -e "${GREEN}[+]${RESET} unicornscan -i ${iface} -mT ${ip}:a -l ${log_dir}/udir/${ip}-tcp.txt"
        unicornscan -i ${iface} -mT ${ip}:a -l ${log_dir}/udir/${ip}-tcp.txt
        ports=$(cat "${log_dir}/udir/${ip}-tcp.txt" | grep open | cut -d"[" -f2 | cut -d"]" -f1 | sed 's/ //g' | tr '\n' ',')
        if [[ ! -z $ports ]]; then 
            # nmap follows up
            echo -e "${BLUE}[*]${RESET} TCP ports for nmap to scan: $ports"
            echo -e "${BLUE}[+]${RESET} nmap -e ${iface} ${nmap_opt} -oX ${log_dir}/ndir/${ip}-tcp.xml -oG ${log_dir}/ndir/${ip}-tcp.grep -p ${ports} ${ip}"
            nmap -e ${iface} ${nmap_opt} -oX ${log_dir}/ndir/${ip}-tcp.xml -oG ${log_dir}/ndir/${ip}-tcp.grep -p ${ports} ${ip} 
        else
            echo -e "${RED}[!]${RESET} No TCP ports found"
        fi
    fi

    # unicornscan identifies all open UDP ports
    if [[ $proto == "udp" || $proto == "all" ]]; then
        echo -e "${GREEN}[+]${RESET} Obtaining all open UDP ports using unicornscan..."
        echo -e "${GREEN}[+]${RESET} unicornscan -i ${iface} -mU ${ip}:a -l ${log_dir}/udir/${ip}-udp.txt"
        unicornscan -i ${iface} -mU ${ip}:a -l ${log_dir}/udir/${ip}-udp.txt
        uports=$(cat "${log_dir}/udir/${ip}-udp.txt" | grep open | cut -d"[" -f2 | cut -d"]" -f1 | sed 's/ //g' | tr '\n' ',')
        if [[ ! -z $uports ]]; then
            # nmap follows up
            echo -e "${GREEN}[*]${RESET} UDP ports for nmap to scan: $uports"
            echo -e "${BLUE}[+]${RESET} nmap -e ${iface} ${nmap_opt} -sU -oX ${log_dir}/ndir/${ip}-udp.xml -oG ${log_dir}/ndir/${ip}-udp.grep -p ${uports} ${ip}"
            nmap -e ${iface} ${nmap_opt} -sU -oX ${log_dir}/ndir/${ip}-udp.xml -oG ${log_dir}/ndir/${ip}-udp.grep -p ${uports} ${ip}
        else
            echo -e "${RED}[!]${RESET} No UDP ports found"
        fi
    fi


echo ""
echo ""
echo -e "${GREEN}[+]${RESET} Check $ip for web services ..."

if [[ ${ports} =~ .*80.* ]]
then
	echo -e "${GREEN}[+]${RESET} Port 80 found, starting Whatweb"
	whatweb ${ip}

elif [[ ${ports} =~ .*443.* ]]
then
        echo -e "${GREEN}[+]${RESET} Port 443 found, starting Whatweb"
        whatweb ${ip}
else
	echo -e "${RED}[!]${RESET} Skipped: whatweb: Port 80 or 443 not found in scan"
fi

if [[ ${ports} =~ .*80.* ]]
then
       	echo -e "${GREEN}[+]${RESET} Port 80 found, starting Nikto"
	nikto -h ${ip}

elif [[ ${ports} =~ .*443.* ]]
then
        echo -e "${GREEN}[+]${RESET} Port 443 found, starting Nikto"
        nikto -h ${ip}

else
        echo -e "${RED}[!]${RESET} Skipped: nikto: Port 80 or 443 not found in scan"
fi

echo ""
echo ""


if [[ ${ports} =~ .*135.* ]]
then
        echo -e "${GREEN}[+]${RESET} Port 135 found, starting Enum4linux"
        enum4linux -a ${ip}
elif [[ ${ports} =~ .*137.* ]]
then
        echo -e "${GREEN}[+]${RESET} Port 137 found, starting Enum4linux"
        enum4linux -a ${ip}
elif [[ ${ports} =~ .*139.* ]]
then
        echo -e "${GREEN}[+]${RESET} Port 139 found, starting Enum4linux"
        enum4linux -a ${ip}
elif [[ ${ports} =~ .*445.* ]]
then
        echo -e "${GREEN}[+]${RESET} Port 445 found, starting Enum4linux"
        enum4linux -a ${ip}
else
        echo -e "${RED}[!]${RESET} Skipped: Netbios ports not found in scan"
fi


done < ${targets}

echo -e "${GREEN}[+]${RESET} Scans completed"
echo -e "${GREEN}[+]${RESET} Results saved to ${log_dir}"
