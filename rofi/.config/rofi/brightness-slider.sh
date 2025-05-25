#!/bin/bash

current_brightness=$(brightnessctl g)
max_brightness=$(brightnessctl m)
percentage=$(( current_brightness * 100 / max_brightness ))

new_brightness=$(seq 0 5 100 | rofi -dmenu -p "Brightness: ${percentage}%" -location 7 -theme-str 'window {width: 20%;}' )

if [ "$new_brightness" != "" ]; then
    brightnessctl s "$new_brightness%"
fi
