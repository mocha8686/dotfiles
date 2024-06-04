#!/bin/bash
op=$(echo -e " Poweroff\n Reboot\n Suspend\n Lock" | wofi -s ~/.config/wofi/wofi.css -i -S dmenu | awk '{print tolower($2)}')

case $op in
	poweroff|reboot|suspend) systemctl "$op";;
	lock) swaylock;;
esac
