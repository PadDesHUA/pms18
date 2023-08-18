#!/bin/bash
device="infdb-srv-01"
#container="influxdb"

cpu=$(ssh $device "top -b -n 1" | awk '/^%Cpu\(s\):/ { print $2 }')
mem_used=$(ssh $device "top -b -n 1" | free |  grep 'Mem:' | awk '{ print $3 }')
mem_total=$(ssh $device "top -b -n 1" | free |  grep 'Mem:' | awk '{ print $2 }')
mem_percentage=$(awk -v used="$mem_used" -v total="$mem_total" 'BEGIN { printf "%.2f", (used / total) * 100 }')  #$($mem_used / $mem_total * 100)
pids=$(ssh $device "top -b -n 1" | awk '/^Tasks:/ { print $2 }')

# Transforming memory values
mem_used_mb=$(awk -v used="$mem_used" 'BEGIN { printf "%.2f", used / 1024 }')
if (( $(echo "$mem_used_mb > 1000" | bc -l) )); then
    mem_used_gb=$(awk -v used_gb="$mem_used_mb" 'BEGIN { printf "%.2f", used_gb / 1024 }')
    mem_used_transformed="$mem_used_gb"
    metric=GB
else
    mem_used_transformed="$mem_used_mb"
    metric=MB
fi
mem_total_gb=$(awk -v total="$mem_total" 'BEGIN { printf "%.2f", total / (1024 * 1024) }')


#docker Metric
#docker_stats=$(ssh control "docker stats --no-stream $container | awk 'NR>1{gsub(/%/, \"\", \$3); gsub(/MiB|GiB/, \"\", \$4); gsub(/MiB|GiB|/, \"\", \$6); gsub(/B|%/, \"\", \$7); gsub(/MB/, \"\", \$14); gsub(/\/,/, \",\"); print \$3 \",\" \$4 \",\" \$6 \",\" \$7 \",\" \$14}'")


echo -e "Device/DockerStats,CPU%,MEM USED($metric),MEM TOTAL,MEM%,PIDS"
echo -e "$device,$cpu,$mem_used_transformed,$mem_total_gb,$mem_percentage,$pids"
#echo -e "$container,$docker_stats"







# CPU% -> top -b -n 1 | awk '/^%Cpu\(s\):/ { print $2 }'

# MEM used -> top -b -n 1 | free |  grep 'Mem:' | awk '{ print $3 }'
# MEM total -> top -b -n 1 | free |  grep 'Mem:' | awk '{ print $2 }'

# MEM% -> mem_percent=$(awk -v used="$mem_used" -v total="$mem_total" 'BEGIN { printf "%.2f", (used / total) * 100 }')

# PIDs -> tasks=$(echo "$top_output" | awk '/^Tasks:/ { print $2 }')

#   echo -e "Device/DockerStats,CPU%,MEM USAGE/LIMIT,MEM%,NET,BLOCK,PIDS"


# #!/bin/bash

# # Run top command and extract desired fields
# top_output=$(top -b -n 1)
# tasks=$(echo "$top_output" | awk '/^Tasks:/ { print $2 }')
# cpu_usage=$(echo "$top_output" | awk '/^%Cpu\(s\):/ { print $2 }')

# # Run free command and extract memory information
# free_output=$(free -k | grep 'Mem:')
# mem_total=$(echo "$free_output" | awk '{ print $2 }')
# mem_used=$(echo "$free_output" | awk '{ print $3 }')
# mem_percent=$(awk -v used="$mem_used" -v total="$mem_total" 'BEGIN { printf "%.2f", (used / total) * 100 }')

# # Create CSV format output
# csv_output="$tasks,$cpu_usage,$mem_total,$mem_used,$mem_percent"

# # Print CSV output
# echo "$csv_output"

# #!/bin/bash

# #devices=("oc-srv-01" "tlg-srv-01" "grf-srv-01" "infdb-srv-01")
# containers=("influxdb")

# docker_stats=$(ssh control "docker stats --no-stream $containers | awk 'NR>1{gsub(/%/, \"\", \$3); gsub(/MiB|GiB/, \"\", \$4); gsub(/MiB/, \"\", \$6); gsub(/B/, \"\", \$7); gsub(/MB/, \"\", \$11); gsub(/MB/, \"\", \$12); gsub(/MB/, \"\", \$13); gsub(/MB/, \"\", \$14); gsub(/\/,/, \",\"); print \$3 \",\" \$4 \",\" \$6 \",\" \$7 \",\" \$11 \",\" \$12 \",\" \$13 \",\" \$14}'")
# docker_stats=$(echo "$docker_stats" | sed 's/%//g')  # Remove remaining % symbols

# echo -e "Device/DockerStats,CPU%,MEM USAGE, MEM LIMIT,MEM%,NET INPUT, NET OUTPUT,BLOCK,PIDS"
# echo "$docker_stats" | while IFS=',' read -r cpu mem_usage mem_limit mem_percent net_input net_output block pids; do
#     echo -e "${containers},${cpu},${mem_usage},${mem_limit},${mem_percent},${net_input},${net_output},${block},${pids}"
# done


#!!! working with only 1 container, above script seperates mem usage and limit
# #!/bin/bash

# #devices=("oc-srv-01" "tlg-srv-01" "grf-srv-01" "infdb-srv-01")
# containers=("influxdb")


#     docker_stats=$(ssh control "docker stats --no-stream $containers | awk 'NR>1{gsub(/%/, \"\", \$3); gsub(/MB|GiB/, \"\", \$4); gsub(/MB/, \"\", \$6); print \$3 \",\" \$4\$5\$6 \",\" \$7 \",0,\" \$11 \$12 \$13 \",\" \$14}'")
#     docker_stats=$(echo "$docker_stats" | sed 's/%//g')  # Remove remaining % symbols
#     docker_stats=$(echo "$docker_stats" | sed 's/MiB//g')  # Remove MiB
#     docker_stats=$(echo "$docker_stats" | sed 's/GiB//g')  # Remove GiB
#     docker_stats=$(echo "$docker_stats" | sed 's/B//g')  # Remove B
#     docker_stats=$(echo "$docker_stats" | sed 's/M//g')  # Remove M


#     echo -e "Device/DockerStats,CPU%,MEM USAGE/LIMIT,MEM%,NET,BLOCK,PIDS"
#     echo -e "$containers,$docker_stats" 




#!!!!BEST RESULT!!!

# #!/bin/bash

# devices=("oc-srv-01" "tlg-srv-01" "infdb-srv-01" "grf-srv-01")
# containers=("owncloud_server" "telegraf" "influxdb" "grafana-server")

# echo "Device/Docker Stats,CPU %,MEM USAGE/LIMIT,MEM %,NET I/O,BLOCK I/O,PIDS" > combined_stats.csv
  
# for ((i = 0; i < ${#devices[@]}; i++)); do
#     device=${devices[$i]}
#     container=${containers[$i]}
                               
#     docker_stats=$(ssh control "docker stats --no-stream $container | awk 'NR>1{gsub(/%/, \"\", \$3); print \$3 \",\" \$4\$5\$6 \",\" \$7 \",0,\" \$11 \$12 \$13 \",\" \$14}'")
#     system_stats=$(ssh $device "top -b -n 1 | awk '
#         /%Cpu\\(s\\):/ { cpu = \$2 }
#         /MiB Mem/ { mem_used = \$4; mem_total = \$6 }
#         /%MEM/ { mem_percent += \$1 }
#         /Tasks:/ { pids = \$2 }
#         END {                  
#             mem_percentage = (mem_total / mem_used) * 100
#             printf \"%.1f,%.1f/%.1f,%.1f,0,0,%d,,,,\\n\", cpu, mem_used, mem_total, mem_percentage, pids
#         }                                                                                               
#     '")
       
#     echo -e "$device,$system_stats\n$container,$docker_stats," >> combined_stats.csv
# done  

#!!! working but alignment missing

# #!/bin/bash

# devices=("oc-srv-01" "tlg-srv-01" "infdb-srv-01" "grf-srv-01")
# containers=("owncloud_server" "telegraf" "grafana-server" "influxdb")

# echo "Device/Docker,CPU %,MEM USAGE/LIMIT,MEM %,PIDS" > combined_stats.csv

# for ((i = 0; i < ${#devices[@]}; i++)); do
#     device=${devices[$i]}
#     container=${containers[$i]}

#     docker_stats=$(ssh control "docker stats --no-stream $container | awk 'NR>1{gsub(/%/, \"\", \$3); print \$3 \",\" \$4\$5\$6 \",\" \$7 \",0,\" \$14}'")
#     system_stats=$(ssh $device "top -b -n 1 | awk '
#         /%Cpu\\(s\\):/ { cpu = \$2 }
#         /MiB Mem/ { mem_used = \$4; mem_total = \$6 }
#         /%MEM/ { mem_percent += \$1 }
#         /Tasks:/ { pids = \$2 }
#         END {
#             printf \"%.1f,%.1f/%.1f,%.1f,%d\\n\", cpu, mem_used, mem_total, mem_percent, pids
#         }
#     '")

    
#     echo -e "$device,$system_stats\n$container,$docker_stats" >> combined_stats.csv
# done


# !!!! The below is working

# #!/bin/bash

# # Get Docker container stats
# docker_command=$(ssh control "docker stats --no-stream owncloud_server | awk 'NR>1{gsub(/%/, \"\", \$3); print \$3 \",\" \$4\$5\$6 \",\" \$7 \",\" \$8\$9\$10 \",\" \$11\$12\$13 \",\" \$14}'")

# # Get system stats using top
# system_command=$(ssh oc-srv-01 "top -b -n 1 | awk '
#     /%Cpu\\(s\\):/ { cpu = \$2 }
#     /MiB Mem/ { mem_used = \$4; mem_total = \$6 }
#     /%MEM/ { mem_percent += \$1 }
#     /Tasks:/ { pids = \$2 }
#     END {
#         printf \"%.1f,%.1f/%.1f,%.1f,%d\\n\", cpu, mem_used, mem_total, mem_percent, pids
#     }
# '")

# # Display combined stats
# echo -e "Stats:"
# echo -e "CPU %,MEM USAGE/LIMIT,MEM %,NET I/O,BLOCK I/O,PIDS"
# echo -e "$docker_command\n$system_command"

# # #!/bin/bash

# # # Get Docker container stats
# # docker_command=$(ssh control "docker stats --no-stream owncloud_server | awk 'NR>1{print \$3 \",\" \$4\$5\$6 \",\" \$7 \",\" \$8\$9\$10 \",\" \$11\$12\$13 \",\" \$14}'")

# # # Get system stats using top
# # system_command=$(ssh oc-srv-01 "top -b -n 1 | awk '
# #     /%Cpu\\(s\\):/ { cpu = \$2 }
# #     /MiB Mem/ { mem_used = \$4; mem_total = \$6 }
# #     /%MEM/ { mem_percent += \$1 }
# #     /Tasks:/ { pids = \$2 }
# #     END {
# #         printf \"%.1f,%.1f/%.1f,%.1f,,,%d\\n\", cpu, mem_used, mem_total, mem_percent, pids
# #     }
# # '")

# # # Display combined stats
# # echo -e "Stats:"
# # echo -e "CPU %,MEM USAGE/LIMIT,MEM %,NET I/O,BLOCK I/O,PIDS"
# # echo -e "$docker_command\n$system_command"




# # #!/bin/bash

# # command1=$(ssh control "docker stats --no-stream owncloud_server | awk 'NR>1{print \$3 \",\" \$4\$5\$6 \",\" \$7 \",\" \$8\$9\$10 \",\" \$11\$12\$13 \",\" \$14}'")

# # # Run the 'top' command and filter output for the PID of owncloud
# # command2=$(ssh oc-srv-01 "top -b -n 1 | grep $(pidof owncloud) | awk '{print \$9 \",\" \$10 \",\" \$11 \",\" \$12 \",\" \$13 \",\" \$1}'")

# # echo -e "CPU %,MEM USAGE/LIMIT,MEM %,NET I/O,BLOCK I/O,PIDS"
# # echo -e "$command1"
# # echo -e "$command2"



# # #!/bin/bash

# # # List of device names
# # devices=("infdb-srv-01" "grf-srv-01" "tlg-srv-01" "oc-srv-01")

# # # Run docker stats command and store output
# # docker_stats_output=$(ssh control 'docker stats --no-stream')

# # # Extract relevant columns from docker stats output
# # filtered_docker_stats_output=$(echo "$docker_stats_output" | awk '{print $1,$2,$6,$7,$8,$9,$10,$11}')

# # # Initialize an associative array to hold device statistics
# # declare -A device_statistics

# # # Iterate over devices and collect statistics
# # for device in "${devices[@]}"; do
# #     echo "Collecting statistics for device: $device"

# #     # Run top command and store output
# #     top_output=$(ssh $device 'top -b -n 1 | grep -E "%Cpu\(s\)|MiB Mem|Netw|Block|Tasks:"')

# #     # Store statistics in the associative array
# #     device_statistics["$device,top"]=$top_output
# # done

# # # Print the collected statistics in a table
# # printf "%-20s %-10s %-20s %-20s %-20s %-20s %-20s %-20s %-20s\n" "Device" "Source" "CPU(%)" "MEM(%)" "NET I/O" "BLOCK I/O" "PIDS" "MEM(MiB)" "CPU(%)"
# # for device in "${devices[@]}"; do
# #     for source in "top" "docker"; do
# #         stats="${device_statistics["$device,$source"]}"
# #         if [ "$source" == "docker" ]; then
# #             stats="$filtered_docker_stats_output"
# #         fi
# #         printf "%-20s %-10s %s\n" "$device" "$source" "$stats"
# #     done
# # done


# # #!/bin/bash

# # # List of device names
# # devices=("infdb-srv-01" "grf-srv-01" "tlg-srv-01" "oc-srv-01")

# # # Iterate over devices and compare results
# # for device in "${devices[@]}"; do
# #     echo "Comparing results for device: $device"

# #     # Run top command and store output
# #     top_output=$(ssh $device 'top -b -n 1')

# #     # Print the collected outputs
# #     echo "Top Output:"
# #     echo "$top_output"

# #     # Add a separator line
# #     echo "--------------------------------------------------"
# # done
# #  # Run docker stats command and store output
# #     docker_stats_output=$(ssh control 'docker stats --no-stream')

# #     echo "Docker Stats Output:"
# #     echo "$docker_stats_output"
