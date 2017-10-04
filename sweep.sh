nmap -sP 174.138.189.142/24 -oG sweep_raw.txt
grep -v ^# sweep_raw.txt > sweep_results.txt
awk '{print $2}' sweep_results.txt > targets.txt
