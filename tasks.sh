#!/bin/bash
echo "System Hostname: $(hostname)"
echo "Operating System: $(lsb_release -d | awk -F"\t" '{print $2}')"
echo "System Uptime: $(uptime -p)"
echo "Linux Kernel Version: $(uname -r)"
echo "CPU Information:"
lscpu | grep -E "Model name|Architecture|CPU\(s\)"
echo "Memory Information:"
free -h | awk 'NR==2{print "Total: " $2 ", Free: " $4}'
echo "Network Interface Information:"
for iface in $(ls /sys/class/net/); do
    ip_addr=$(ip addr show $iface | grep 'inet ' | awk '{print $2}' | cut -d/ -f1)
    mac_addr=$(cat /sys/class/net/$iface/address)
    if [[ -n $ip_addr ]]; then
        echo "$iface - IP Address: $ip_addr, MAC Address: $mac_addr"
    fi
done


echo "Filesystem Utilization and Types:"
df -hT | grep -v 'tmpfs' | awk '{print $1, $2, $3, $5, $6}'

echo "Last 5 lines of log file containing 'error':"
journalctl -xe | grep -i "error" | tail -n 5

