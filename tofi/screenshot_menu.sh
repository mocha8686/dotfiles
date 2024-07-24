#!/bin/bash
op=$(echo -e "Select region (clipboard)\nScreen capture (clipboard)\nSelect region (imv)\nScreen capture (imv)\nSelect region\nScreen capture" | tofi --prompt-text "screenshot: ")

sleep 0.5

case $op in
	"Screen capture (clipboard)") grim - | wl-copy ;;
	"Select region (clipboard)") grim -g "$(slurp)" - | wl-copy ;;
	"Screen capture") grim ;;
	"Select region") grim -g "$(slurp)" ;;
	"Screen capture (imv)") grim /tmp/imv && imv /tmp/imv ;;
	"Select region (imv)") grim -g "$(slurp)" /tmp/imv && imv /tmp/imv ;;
esac
