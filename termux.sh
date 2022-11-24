#!/bin/bash

#Colours
greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"
turquoiseColour="\e[0;36m\033[1m"
grayColour="\e[0;37m\033[1m"


trap ctrl_c INT

function ctrl_c (){
	echo -e "\$(redColour)Saliendo....${endCOlour}"
	tput cnorm
}

function panel_Ayuda(){
	echo -e "\n${redColour}\t-+-+-+-[!] Uso de la Herramienta: ./termux.sh-+-+-+-+-+·${endColour}"
	echo -e "\n\t[-g]\t${yellowColour}Modo de Geolocalizador${endColour}\t${grayColour}[-g geo]${endColour}${yellowColour}[example ./termux.sh -g geo -p gps -r once]${endColour}"
	echo -e "\n\t\t${purpleColour}[-p]\t${endColour}${yellowColour}[gps/network/passive](default:gps)"
	echo -e "\n\t\t${purpleColour}[-r]\t${endColour}${yellowColour}[once/last/update](default:once)${endColour}"
	echo -e "\n\t[-l]\t${yellowColour}Modo luz${endColour}\t${grayColour}[-l luz]${endColour}"
	echo -e "\n\t\t\t${yellowColour}[on/off]${endColour}"
	echo -e "\n\t[-n]\t${yellowColour}Modo numero${endColour}\t${grayColour}[-n num]${endColour}"
}

function geo(){
	echo -e "\n${blueColour}[*]${endColour}Buscando el lugar:\n"
	echo -en "${yellowColour}[-]${endColour}Lugar es "
	echo -e "$(termux-location -p $gps_geo -r $once_geo >> localizacion.txt)"
	cat localizacion.txt | grep "latitude" | cut -d ":" -f 2 | cut -d "," -f 1 >> lati.txt
	cat localizacion.txt | grep "longitude" | cut -d ":" -f 2 | cut -d "," -f 1 >> long.txt
	echo -e "\n${yellowColour}[*]${endColour}Latitud:\t${greenColour}$(cat lati.txt)${endColour}"
	echo -e "\n${yellowColour}[*]${endColour}Longitud:\t${greenColour}$(cat long.txt)${endColour}"
	echo -e "${redColour}[*]${endColour}${greenColour}https://www.google.es/maps/@$(cat lati.txt)/$(cat long.txt)${endColour}" >> j
	echo -en "\n${redColour}[+]${endColour}Enlace:\t"
	echo -e "${redColour}[*]${endColour}${greenColour}https://www.mapsdirections.info/coordenadas-de-googlemaps.html${endColour}"
	echo -en "\n${redColour}[+]${endColour}Enlace:\t"
	echo -e "${greenColour}$(cat j | sed 's/ // g')\n${endColour}"
	rm j 2>/dev/null
	tput cnorm
}

#Latitude: cat hol.txt | grep "latitude" | cut -d  ":" -f 2 | cut -d "," -f 1
#Longitude: cat hol.txt | grep "longitude" | cut -d ":" -f 2 | cut -d "," -f 1
#https://www.google.es/maps/@40.3845787,-3.631923
#Numero for i in "$(cat k.txt | grep 'name' | cut -d "," -f 1)";do  echo -e "\nEste es numero: $i\n" | sort -u ; done

function num(){
	while True:
		do
			echo -en "${yellowColour}[*]${endColour}Numero de contactos:" && read numero
			if [ ! $numero ]; then
				echo -e "${redColour}[!]${endColour}Por defecto 30."
			fi
		done
}
#Quito de Cadenas el (")
#cat orden2 | grep "+34" | sort -u | sed -i s/'"'/""/g orden2
#Sacar el Orden
#cat orden2 | grep "+34" | sort -u


function luz (){
	if [ $modo == "on" ]; then
		echo -e "${redColour}[*]${endColour}${greenColour}Encendido${endColour}"
		termux-torch on
	else
		echo -e "${redColour}[*]${endColour}${turquoiseColour}Apagado${endColour}"
		termux-torch off
	fi
}

parametro=0;while getopts "g:l:n:h:p:r:m:" arg; do
	case  $arg in
		g) geocalizar=$OPTARG; let parametro+=1;;
		l) luz=$OPTARG; let parametro+=1;;
		m) modo=$OPTARG; let parametro+=1;;
		n) numero=$OPTARG; let parametro+=1;;
		p) gps_geo=$OPTARG; let parametro+=1;;
		r) once_geo=$OPTARG; let parametro+=1;;
		h) panel_Ayuda;;
	esac
done

tput civis

if [ $parametro -eq 0 ]; then
	panel_Ayuda
else
	if [ "$(echo $geocalizar)" == "geo" ]; then
		clear
		geo
		rm *.txt
#		cp a localizacion.txt
	elif [ "$(echo $luz)" == "luz" ]; then
		luz
		tput cnorm
	elif [ "$(echo $numero)" == "num" ]; then
		num
	fi
fi
