#!/bin/bash

battery_info=$(upower -i /org/freedesktop/UPower/devices/battery_BAT0 | grep -E "percentage|time to empty|time to full")

echo "$battery_info" | rofi -dmenu -p "Battery Status" -location 7 -theme-str 'window {width: 25%;}'
