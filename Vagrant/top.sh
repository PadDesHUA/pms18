#!/bin/bash


# Collect process information using top command
top_output=$(top -b -n 1)

# Extract header and process information
header=$(echo "$top_output" | head -n 7)
process_info=$(echo "$top_output" | tail -n +8)

# Format and print the header
echo "$header"

# Print separator line
echo "--------------------------------------------------------------------------------"

# Print formatted process information
echo "$process_info"



#top_output=$(top -b -n 1 | awk 'NR > 7 {print $1,$2,$9,$10,$12,$NF}')


#echo -e top_output
#echo -e $top_output "/t"
