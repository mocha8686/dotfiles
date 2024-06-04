#!/bin/bash
op=$(echo -e " Poweroff\n Reboot\n Lock" | wofi -s ~/.config/wofi/wofi.css -i -S dmenu | awk '{print tolower($2)}')

case $op in
	poweroff|reboot) systemctl "$op";;
	lock) swaylock;;
esac
