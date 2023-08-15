#!/bin/bash

googledns=$(ping 8.8.8.8 -c 1 | grep "from" | cut -d "=" -f 4 | cut -f 1 -d " ")
opendns=$(ping 1.1.1.1 -c 1 | grep "from" | cut -d "=" -f 4 | cut -f 1 -d " ")


echo -e googledns "\t"  opendns
echo -e "$googledns" "\t" "$opendns"
