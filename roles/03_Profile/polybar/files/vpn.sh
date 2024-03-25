#!/bin/bash

vpn-switcher(){
  input_str="$1"

  if [[ "$input_str" == "connect" ]]; then
    echo $ADFS_PASSWORD | sudo openconnect --protocol=gp --os=linux-64 --background --passwd-on-stdin --user=$ADFS_USER_WORK --server=$VPN_WORK_SRV --authgroup=$VPN_WORK_SRV_GROUP
    notify-send -a "VPN" -u normal "Connected"
  elif [[ "$input_str" == "disconnect" ]]; then
    sudo /usr/bin/kill $(ps aux | rg openconnect | rg background | awk '{{ print $2}}')
    notify-send -a "VPN" -u normal "Disconnected"
  else
    return 0
  fi
}

vpn-switcher "$1"

VAR=$(ps aux | rg openconnect | rg background | awk '{{ print $2}}')
if [[ -z $VAR ]]; then echo 󱕴 ; else echo %{F\#7AB87A}󰕥%{F-}; fi
