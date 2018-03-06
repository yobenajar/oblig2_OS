#!/bin/bash

program=firefox

while read ans
 do
 	majflt=$(ps --no-headers -o maj_flt "$ans")

 	if [ "$majflt" -gt 1000 ] 
 		then 
 			echo "$program $ans har forårsaket $majflt page faults (mer enn 1000!)" 
 	else
 		 	echo "$program $ans har forårsaket $majflt page faults"
	fi
done < <(pgrep $program)