#!/bin/bash 

upower -i /org/freedesktop/UPower/devices/battery_BAT0 | \
    grep -E "state|percentage|time to empty|time to full" | \
    rofi -theme ~/.config/rofi/battery-info.rasi -e "$(cat)"
    # rofi -dmenu -theme ~/.config/rofi/battery-info.rasi -p "Battery Info"
