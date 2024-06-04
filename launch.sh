#!/bin/bash
killall -q polybar
polybar 2>&1 left | tee -a /tmp/mybar.log & disown
polybar 2>&1 middle | tee -a /tmp/mybar.log & disown
polybar 2>&1 right | tee -a /tmp/mybar.log & disown
