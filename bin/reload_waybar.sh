#!/bin/bash
killall waybar
nohup waybar 2>&1 >/dev/null & disown
