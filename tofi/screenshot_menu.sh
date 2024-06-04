#!/bin/bash
op=$(echo -e "Screen capture\nSelect region\nScreen capture (clipboard)\nSelect region (clipboard)" | tofi --prompt-text "screenshot: ")

sleep 0.5

case $op in
	"Screen capture (clipboard)") grim - | wl-copy ;;
	"Select region (clipboard)") grim -g "$(slurp)" - | wl-copy ;;
	"Screen capture") grim ;;
	"Select region") grim -g "$(slurp)" ;;
esac
