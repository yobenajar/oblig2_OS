#!/bin/bash 

# ******************************* FUNKSJONER *********************************

function meny {
	echo
	echo "1 - Hvem er jeg og hva er navnet paa dette scriptet?"
	echo "2 - Hvor lenge er det siden siste boot?"
	echo "3 - Hvor mange prosesser og tr ̊ader finnes?"
	echo "4 - Hvor mange context switch'er fant sted siste sekund?"
	echo "5 - Hvor stor andel av CPU-tiden ble benyttet i kernelmode og i usermode siste sekund?"
	echo "6 - Hvor mange interrupts fant sted siste sekund?"
	echo "9 - Avslutt dette scriptet"
}

# ******************************* "MAIN" **************************************


function contextswitch {
	switch1=$(grep ctxt /proc/stat | awk '{print $2}')
	sleep 1
	switch2=$(grep ctxt /proc/stat | awk '{print $2}')
	echo $((switch2-switch1))
}

function interrupts {
	int1=$(grep intr /proc/stat | awk '{print $2}')
	sleep 1
	int2=$(grep intr /proc/stat | awk '{print $2}')
	echo $((int2-int1))
}

function cpuTid {
	usermode1=$(grep -m 1 cpu /proc/stat | awk '{print $2}')
	kernelmode1=$(grep -m 1 cpu /proc/stat | awk '{print $4}')
	sleep 1
	usermode2=$(grep -m 1 cpu /proc/stat | awk '{print $2}')
	kernelmode2=$(grep -m 1 cpu /proc/stat | awk '{print $4}')

	user=$((usermode2-usermode1))
	kernel=$((kernelmode2-kernelmode1))

	sum=$((user + kernel))

	prosent=$((100 / sum))

	echo "$((user*prosent)) % av det siste sekundet til usermode"
	echo "$((kernel*prosent)) % av det siste sekundet til kernelmode"
}

meny
while [ "$tall" != 9 ] 
do
	#meny
	echo  
	echo -n "Skriv inn et tall fra menyen: "
	read -r tall


	if [ "$tall" -lt 7 -o "$tall" == 9 ]
	then
		case "$tall" in 
	 		1) echo "Jeg er $(whoami), og dette scriptet heter $0"
				;;
			
			2) echo "Siste boot var: $(uptime -p)"
				;;

			3) echo "Det finnes $(ps auxh -T | wc -l) prosesser og tråder"	
				;;
			
			4) echo "Det var $(contextswitch) context switch'er i det siste sekundet"
				;;
			
			5) cpuTid
				;;
			
			6) echo "Det var $(interrupts) interrupts i det siste sekundet"
				;;
	
			9) echo "Programmet er avsluttet"
				;;
		esac 
	else 
		echo
		echo
		echo "Du har skrevet et tall som ikke finnes i denne menyen"
		meny
		echo "Skriv inn et gyldig tall (1,2,3,4,5,6,9)"
	fi 	
done