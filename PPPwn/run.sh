#!/bin/bash

if [ -f /boot/firmware/PPPwn/config.sh ]; then
source /boot/firmware/PPPwn/config.sh
fi
if [ -f /boot/firmware/PPPwn/pconfig.sh ]; then
source /boot/firmware/PPPwn/pconfig.sh
fi

if [ -z $CPPMETHOD ]; then CPPMETHOD="xfangfang"; fi
if [ -z $INTERFACE ]; then INTERFACE="eth0"; fi
if [ -z $FIRMWAREVERSION ]; then FIRMWAREVERSION="11.00"; fi
if [ -z $USBETHERNET ]; then USBETHERNET=false; fi
if [ -z $STAGE2METHOD ]; then STAGE2METHOD="goldhen"; fi
if [ -z $USEIPV6 ]; then USEIPV6=false; fi
if [ -z $DELAYSTART ]; then DELAYSTART="0"; fi
if [ -z $TIMEOUT ]; then TIMEOUT="5m"; fi

if [ -z $XFWAP ]; then XFWAP="1"; fi
if [ -z $XFGD ]; then XFGD="4"; fi
if [ -z $XFBS ]; then XFBS="0"; fi
if [ -z $XFNWB ]; then XFNWB=true; fi
if [ $USEIPV6 = true ] ; then
XFIP="fe80::9f9f:41ff:9f9f:41ff"
else
XFIP="fe80::4141:4141:4141:4141"
fi
if [ $XFNWB = true ] ; then
XFNW="--no-wait-padi"
else
XFNW=""
fi

PITYP=$(tr -d '\0' </proc/device-tree/model) 
if [[ $PITYP == *"Raspberry Pi 2"* ]] ;then
CPPBIN="pppwn7"
elif [[ $PITYP == *"Raspberry Pi 3"* ]] ;then
CPPBIN="pppwn64"
elif [[ $PITYP == *"Raspberry Pi 4"* ]] ;then
CPPBIN="pppwn64"
elif [[ $PITYP == *"Raspberry Pi 5"* ]] ;then
CPPBIN="pppwn64"
elif [[ $PITYP == *"Raspberry Pi Zero 2"* ]] ;then
CPPBIN="pppwn64"
elif [[ $PITYP == *"Raspberry Pi Zero"* ]] ;then
CPPBIN="pppwn11"
elif [[ $PITYP == *"Raspberry Pi"* ]] ;then
CPPBIN="pppwn11"
else
CPPBIN="pppwn64"
fi
arch=$(getconf LONG_BIT)
if [ $arch -eq 32 ] && [ $CPPBIN = "pppwn64" ] && [[ ! $PITYP == *"Raspberry Pi 4"* ]] && [[ ! $PITYP == *"Raspberry Pi 5"* ]] ; then
CPPBIN="pppwn7"
fi

STAGE1F="/boot/firmware/PPPwn/stage1/stage1_${FIRMWAREVERSION//.}.bin"

if [[ ${STAGE2METHOD,,} == "goldhen" ]] || [[ ${STAGE2METHOD,,} == *"gold"* ]] ;then
STAGE2PATH="goldhen"
elif [[ ${STAGE2METHOD,,} == "hen" ]] || [[ ${STAGE2METHOD,,} == *"vtx"* ]] ;then
STAGE2PATH="vtxhen"
elif [[ ${STAGE2METHOD,,} == "bestpig" ]] || [[ ${STAGE2METHOD,,} == *"pig"* ]] ;then
STAGE2PATH="bestpig"
else
STAGE2PATH="Hey, joe97tab why not add new stage2"
fi

if [ -f /boot/firmware/PPPwn/stage2/$STAGE2PATH/stage2_${FIRMWAREVERSION//.}.bin ] ; then
	STAGE2F="/boot/firmware/PPPwn/stage2/$STAGE2PATH/stage2_${FIRMWAREVERSION//.}.bin"
else
	STAGE2F="/boot/firmware/PPPwn/stage2/TheOfficialFloW/stage2_${FIRMWAREVERSION//.}.bin"
fi

if [[ $CPPMETHOD == *"1"* ]] || [[ ${CPPMETHOD,,} == *"v"* ]] ;then
CPPBIN+='v1'
PPPwnPS4="$CPPBIN --interface "$INTERFACE" --fw "${FIRMWAREVERSION//.}" --stage1 "$STAGE1F" --stage2 "$STAGE2F""
elif [[ $CPPMETHOD == *"2"* ]] || [[ ${CPPMETHOD,,} == *"s"* ]] ;then
if [[ $STAGE2PATH == "goldhen" ]] ;then
if [[ $FIRMWAREVERSION == "9.00" ]] || [[ $FIRMWAREVERSION == "9.60" ]] || [[ $FIRMWAREVERSION == "10.00" ]] || [[ $FIRMWAREVERSION == "10.01" ]] || [[ $FIRMWAREVERSION == "11.00" ]] ; then
XFGH="-gh"
else
XFGH=""
fi
else
XFGH=""
fi 
PPPwnPS4="$CPPBIN --interface "$INTERFACE" --fw "${FIRMWAREVERSION//.}" --ipv $XFIP --wait-after-pin $XFWAP --groom-delay $XFGD --buffer-size $XFBS $XFNW $XFGH"
else
if [ $USEIPV6 = false ]; then
CPPBIN+='ipv4'
else
CPPBIN+='ipv6'
fi
PPPwnPS4="$CPPBIN --interface "$INTERFACE" --fw "${FIRMWAREVERSION//.}" --stage1 "$STAGE1F" --stage2 "$STAGE2F" --wait-after-pin $XFWAP --groom-delay $XFGD --buffer-size $XFBS $XFNW"
fi

echo -e "\n\n\033[36m
 _    _          _____ _  __  _____   _____ _  _        
 | |  | |   /\   / ____| |/ / |  __ \ / ____| || |       
 | |__| |  /  \ | |    | ' /  | |__) | (___ | || |_      
 |  __  | / /\ \| |    |  <   |  ___/ \___ \|__   _|     
 | |  | |/ ____ \ |____| . \  | |     ____) |  | |       
 |_|  |_/_/    \_\_____|_|\_\ |_|    |_____/   |_|       
   ___   ___   ___ ______ ___ ___   ___ ___   ___   ___  
  / _ \ / _ \ / _ \____  / _ \__ \ / _ \__ \ / _ \ / _ \ 
 | | | | (_) | (_) |  / / (_) | ) | (_) | ) | | | | (_) |
 | | | |\__, |> _ <  / / \__, |/ / \__, |/ /| | | |\__, |
 | |_| |  / /| (_) |/ /    / // /_   / // /_| |_| |  / / 
  \___/  /_/  \___//_/    /_/|____| /_/|____|\___/  /_/  
\033[0m
\n\033[33mhttps://github.com/TheOfficialFloW/PPPwn\033[0m\n" | sudo tee /dev/tty1

echo -e "\033[37mHACK      : CHEPGAME.NET\033[0m" | sudo tee /dev/tty1

if [[ $((DELAYSTART)) -ge 1 ]] && [[ $((DELAYSTART)) -le 15 ]]; then
coproc read -t $DELAYSTART && wait "$!" || true
fi

sudo systemctl stop pppoe
if [ $USBETHERNET = true ] ; then
	echo '1-1' | sudo tee /sys/bus/usb/drivers/usb/unbind >/dev/null
	coproc read -t 1 && wait "$!" || true
	echo '1-1' | sudo tee /sys/bus/usb/drivers/usb/bind >/dev/null
	coproc read -t 1 && wait "$!" || true
	sudo ip link set $INTERFACE up
	coproc read -t 2 && wait "$!" || true
else
	sudo ip link set $INTERFACE down
	coproc read -t 1 && wait "$!" || true
	sudo ip link set $INTERFACE up
	coproc read -t 2 && wait "$!" || true
fi

echo -e "\n\033[36m$PITYP\033[92m\nFirmware:\033[93m $FIRMWAREVERSION\033[92m\nInterface:\033[93m $INTERFACE\033[0m" | sudo tee /dev/tty1

echo -e "\033[92mPPPwn:\033[93m C++ $CPPBIN \033[0m" | sudo tee /dev/tty1

echo -e "\033[95mReady for console connection\033[0m" | sudo tee /dev/tty1

while [ true ]
do
while read -r stdo ; 
do 
if [[ $stdo  == "[+] Done!" ]] ;then
coproc read -t 6 && wait "$!" || true
sudo ip link set $INTERFACE down
sudo poweroff
fi
done < <(timeout $TIMEOUT sudo /boot/firmware/PPPwn/$PPPwnPS4)
sudo ip link set $INTERFACE down
coproc read -t 1 && wait "$!" || true
sudo ip link set $INTERFACE up
coproc read -t 2 && wait "$!" || true
done
