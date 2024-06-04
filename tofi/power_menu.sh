#!/bin/bash
op=$(echo -e "Poweroff\nReboot\nLock" | tofi --prompt-text "power: " | awk '{print tolower($1)}')

echo "$op"

case $op in
	poweroff|reboot) systemctl "$op";;
	lock) loginctl lock-session;;
esac
