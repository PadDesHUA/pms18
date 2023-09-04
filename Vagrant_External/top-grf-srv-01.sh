#!/bin/bash
device="grf-srv-01"

output=$(ssh $device "top -b -n 1")

cpu_percent=$(echo "$output" | awk '/%Cpu/ {print $2}')
mem_total=$(echo "$output" | awk '/MiB Mem/ {print $4}')
mem_used=$(echo "$output" | awk '/MiB Mem/ {print $8}')
mem_percent=$(echo "scale=2; ($mem_used / $mem_total) * 100" | bc)
pids=$(echo "$output" | awk '/Tasks:/{print $2}')

echo -e "Device Name,CPU(%),Mem Total,Mem Used,Mem(%),PID's"
echo -e "$device,$cpu_percent,$mem_total,$mem_used,$mem_percent,$pids"