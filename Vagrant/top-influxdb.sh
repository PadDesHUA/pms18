#!/bin/bash
#device="infdb-srv-01"
container="influxdb"

# cpu=$(ssh $device "top -b -n 1" | awk '/^%Cpu\(s\):/ { print $2 }')
# mem_used=$(ssh $device "top -b -n 1" | free |  grep 'Mem:' | awk '{ print $3 }')
# mem_total=$(ssh $device "top -b -n 1" | free |  grep 'Mem:' | awk '{ print $2 }')
# mem_percentage=$(awk -v used="$mem_used" -v total="$mem_total" 'BEGIN { printf "%.2f", (used / total) * 100 }')  #$($mem_used / $mem_total * 100)
# pids=$(ssh $device "top -b -n 1" | awk '/^Tasks:/ { print $2 }')

# # Transforming memory values
# mem_used_mb=$(awk -v used="$mem_used" 'BEGIN { printf "%.2f", used / 1024 }')
# if (( $(echo "$mem_used_mb > 1000" | bc -l) )); then
#     mem_used_gb=$(awk -v used_gb="$mem_used_mb" 'BEGIN { printf "%.2f", used_gb / 1024 }')
#     mem_used_transformed="$mem_used_gb"
#     metric=GB
# else
#     mem_used_transformed="$mem_used_mb"
#     metric=MB
# fi
# mem_total_gb=$(awk -v total="$mem_total" 'BEGIN { printf "%.2f", total / (1024 * 1024) }')


#docker Metric
docker_stats=$(ssh control "docker stats --no-stream $container | awk 'NR>1{gsub(/%/, \"\", \$3); gsub(/MiB|GiB/, \"\", \$4); gsub(/MiB|GiB|/, \"\", \$6); gsub(/B|%/, \"\", \$7); gsub(/MB/, \"\", \$14); gsub(/\/,/, \",\"); print \$3 \",\" \$4 \",\" \$6 \",\" \$7 \",\" \$14}'")


echo -e "Device/DockerStats,CPU%,MEM USED,MEM TOTAL,MEM%,PIDS"
# echo -e "$device,$cpu,$mem_used_transformed,$mem_total_gb,$mem_percentage,$pids"
echo -e "$container,$docker_stats"