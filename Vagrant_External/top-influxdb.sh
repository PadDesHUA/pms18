#!/bin/bash
container="influxdb"

#docker Metric
docker_stats=$(ssh control "docker stats --no-stream $container | awk 'NR>1{gsub(/%/, \"\", \$3); gsub(/MiB|GiB/, \"\", \$4); gsub(/MiB|GiB|/, \"\", \$6); gsub(/B|%/, \"\", \$7); gsub(/MB/, \"\", \$14); gsub(/\/,/, \",\"); print \$3 \",\" \$4 \",\" \$6 \",\" \$7 \",\" \$14}'")


echo -e "Device/DockerStats,CPU%,MEM USED,MEM TOTAL,MEM%,PIDS"
echo -e "$container,$docker_stats"