nmap -sP 192.168.2.0/24 > /dev/null -oG sweep_raw
grep -v ^# sweep_raw > sweep_results
awk '{print $2}' sweep_results > targets
~/scripts/ramakandra.sh -t targets
