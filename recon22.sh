#!/bin/bash
# this script runs nmap vuln scanner on port 22 of a given ip.
if [ -z "$1" ]
then
        echo "Usage: ./recon22.sh <IP>"
        exit 1
fi

printf "\n----- SSH -----\n\n" > results22

echo "Running Nmap..."
nmap -sCV -p 22 $1 | tail -n +5 | head -n -3 >> results22

while read line
do
        if [[ $line == *open* ]] && [[ $line == *ssh* ]]
        then
		if [[ $line == *1.0* ]]
		then
                	echo "Running nmap scripts for ssh version 1..."
                	nmap -p 22 $1 --script sshv1 > temp1
		else
			echo "Ssh uses protocol 2.0... " > temp2
			echo "These scripts may help you:" >> temp2
			echo "nmap -p 22 <ip> --script ssh-auth-methods" >> temp2
			echo "nmap -p 22 <ip> --script ssh-brute" >> temp2
			echo "nmap -p 22 <ip> --script ssh-hostkey" >> temp2
			echo "nmap -p 22 <ip> --script ssh-publickey-acceptance" >> temp2
			echo " nmap -p 22 <ip> --script ssh-run" >> temp2
			echo "nmap -p 22 <ip> --script ssh2-enum-algos" >> temp2
			echo "These scripts will need to be providen with arguments. For instance:" >> temp2
			echo "nmap <ip> -p 22 --script ssh-brute --script-args userdb=users.txt,passdb=/usr/share/nmap/nselib/data/passwords.lst" >> temp2
			echo "Also, to locate nmap vuln scripts for ssh, just run: locate *.nse | grep ssh" >> temp2
		fi
        fi
done < results22

if [ -e temp1 ]
then
        printf "\n----- sshv1 -----\n\n" >> results22
        cat temp1 >> results22
        rm temp1
fi

if [ -e temp2 ]
then
    printf "\n----- sshv2 -----\n\n" >> results22
        cat temp2 >> results22
        rm temp2
fi

cat results22
