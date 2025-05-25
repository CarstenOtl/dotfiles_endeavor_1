#!/bin/bash

current_volume=$(pactl get-sink-volume @DEFAULT_SINK@ | grep -oP '\d+%' | head -1 | tr -d '%')

new_volume=$(seq 0 5 100 | rofi -dmenu -p "Volume: $current_volume%" -location 7 -theme-str 'window {width: 20%;}' )

if [ "$new_volume" != "" ]; then
    pactl set-sink-volume @DEFAULT_SINK@ "$new_volume%"
fi
