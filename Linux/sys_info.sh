#!/bin/bash

output=$HOME/research/sys_info.txt
echo "A Quick System Audit Script"
date
files=(
'/etc/shadow'
'/etc/passwd'
)
for file in ${files[@]};
do
	echo $file >>$output	
	ls -l $file >> $output
done

echo "Machine type:"
echo $MACHTYPE
echo -e "Uname info: $(uname -a) \n" >> $output
echo -e "IP info: $(ip addr | grep -i enp0s3) \n" >> $output
echo "Hostname: $(hostname -s)" >> $output
echo "DNS Servers: "
cat /etc/resolv.conf
echo "CPU Info:"
lscpu | grep CPU
echo "Disk Usage"
df -H | head -2
echo "Who is logged in"
who
echo "777 files: $(find ~ -type f -perm 0777)" >> $output


