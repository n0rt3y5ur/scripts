#!/bin/bash
# this script runs nmap, gobuster and whatweb on port 80 of a given ip.
if [ -z "$1" ]
then
        echo "Usage: ./recon80.sh <IP>"
        exit 1
fi

printf "\n----- NMAP -----\n\n" > results80

echo "Running Nmap..."
nmap $1 | tail -n +5 | head -n -3 >> results80

while read line
do
        if [[ $line == *open* ]] && [[ $line == *http* ]]
        then
                echo "Running Gobuster..."
                gobuster dir -u $1 -w /usr/share/wordlists/dirb/common.txt -qz > temp1

        echo "Running WhatWeb..."
        whatweb $1 -v > temp2
        fi
done < results80

if [ -e temp1 ]
then
        printf "\n----- DIRS -----\n\n" >> results80
        cat temp1 >> results80
        rm temp1
fi

if [ -e temp2 ]
then
    printf "\n----- WEB -----\n\n" >> results80
        cat temp2 >> results80
        rm temp2
fi

cat results80
