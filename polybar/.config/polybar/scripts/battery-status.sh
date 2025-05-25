#!/bin/bash

# Temp file to hold charging animation frame index
STATE_FILE="/tmp/polybar_battery_frame"

# Get battery percentage
percentage=$(upower -i /org/freedesktop/UPower/devices/battery_BAT0 | awk '/percentage/ {print $2}' | tr -d '%')

# Get charging state
state=$(upower -i /org/freedesktop/UPower/devices/battery_BAT0 | awk '/state/ {print $2}')

# Discharging icons
icons=(    )

# Charging animation icons
charging_icons=(󰢟 󰂆 󰂈 󰂉 󰂊 󰂅)

# Select battery level icon index
index=$((percentage / 20))
if [ $index -gt 4 ]; then index=4; fi

# Handle animation frame increment
if [ "$state" = "charging" ]; then
    # Initialize state file if it doesn't exist
    if [ ! -f "$STATE_FILE" ]; then
        echo 0 > "$STATE_FILE"
    fi

    # Read current frame
    frame=$(cat "$STATE_FILE")

    # Output charging icon frame + percentage
    echo "${charging_icons[$frame]} ${percentage}%"

    # Increment frame and loop back
    next_frame=$(( (frame + 1) % ${#charging_icons[@]} ))
    echo "$next_frame" > "$STATE_FILE"
else
    # If not charging, just show static icon and percentage
    echo "${icons[$index]} ${percentage}%"
    # Reset animation frame
    echo 0 > "$STATE_FILE"
fi
