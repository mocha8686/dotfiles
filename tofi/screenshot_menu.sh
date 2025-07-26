#!/bin/bash
op=$(echo -e "Select region (clipboard)\nScreen capture (clipboard)\nSelect region (imv)\nScreen capture (imv)\nSelect region\nScreen capture" | tofi --prompt-text "screenshot: ")

sleep 0.5

case $op in
"Screen capture (clipboard)") grim - | wl-copy ;;
"Select region (clipboard)") grim -g "$(slurp)" - | wl-copy ;;
"Screen capture") grim ;;
"Select region") grim -g "$(slurp)" ;;
"Screen capture (imv)")
	dir=$(mktemp)
	grim "$dir"
	hyprctl dispatch "exec [float; pin; move 100%-w-20; size 25%] imv $dir"
	;;
"Select region (imv)")
	dir=$(mktemp)
	dim=$(slurp)
	grim -g "$dim" "$dir"
	size=$(echo "$dim" | cut -d " " -f 2 | tr "x" " ")
	hyprctl dispatch "exec [float; pin; size $size] imv $dir" ;;
esac
