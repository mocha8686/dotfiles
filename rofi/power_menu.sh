#!/bin/bash
op=$(echo -e " Poweroff\n Reboot\n Lock" | rofi -dmenu -no-show-icons -i -p "power" | awk '{print tolower($2)}')

case $op in
	poweroff|reboot) systemctl "$op";;
	lock) loginctl lock-session;;
esac
