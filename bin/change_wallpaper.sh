#!/bin/bash

wallust run "$@"

# hyprpaper
if command -v hyprpaper >/dev/null; then
	killall -q hyprpaper
	hyprpaper >/dev/null 2>&1 &
	disown -h
fi
