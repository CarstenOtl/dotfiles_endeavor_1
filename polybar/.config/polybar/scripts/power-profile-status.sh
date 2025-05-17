#!/bin/bash

get_icon() {
    case "$1" in
        performance)
            echo " "  # FontAwesome Tachometer icon
            ;;
        balanced)
            echo " "  # FontAwesome Balance Scale
            ;;
        power-saver)
            echo " "  # FontAwesome Exclamation
            ;;
        *)
            echo "?"  # Unknown state
            ;;
    esac
}

case "$1" in
    --next)
        current=$(powerprofilesctl get)
        case "$current" in
            performance)
                powerprofilesctl set balanced
                ;;
            balanced)
                powerprofilesctl set power-saver
                ;;
            power-saver)
                powerprofilesctl set performance
                ;;
        esac
        ;;
esac

current_profile=$(powerprofilesctl get)
get_icon "$current_profile"
