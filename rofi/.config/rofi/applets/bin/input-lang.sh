#!/usr/bin/env bash

## Input language picker -- rofi dmenu applet in the style of
## applets/bin/quicklinks.sh. Switches the active GNOME/ibus input source.
## See pop-shell/.config/pop-shell/pop-shell-setup.md for why this exists
## and why it shells out to input-lang-en/de/zh instead of calling
## `ibus engine` directly.

# Import Current Theme
source "$HOME"/.config/rofi/applets/shared/theme.bash
theme="$type/$style"

# Theme Elements
prompt='Input Language'
mesg="Current: $(ibus engine 2>/dev/null)"

if [[ ("$theme" == *'type-1'*) || ("$theme" == *'type-3'*) || ("$theme" == *'type-5'*) ]]; then
  list_col='1'
  list_row='3'
elif [[ ("$theme" == *'type-2'*) || ("$theme" == *'type-4'*) ]]; then
  list_col='3'
  list_row='1'
fi

if [[ ("$theme" == *'type-1'*) || ("$theme" == *'type-5'*) ]]; then
  efonts="Hack Nerd Font 10"
else
  efonts="Hack Nerd Font 28"
fi

# Options
option_1="en"
option_2="de"
option_3="zh"

# Rofi CMD
rofi_cmd() {
  rofi -theme-str "listview {columns: $list_col; lines: $list_row;}" \
    -theme-str 'textbox-prompt-colon {str: "";}' \
    -theme-str "element-text {font: \"$efonts\";}" \
    -dmenu \
    -i \
    -p "$prompt" \
    -mesg "$mesg" \
    -markup-rows \
    -normal-window \
    -theme ${theme}
}

# Pass variables to rofi dmenu
run_rofi() {
  echo -e "$option_1\n$option_2\n$option_3" | rofi_cmd
}

# Execute Command
run_cmd() {
  if [[ "$1" == '--opt1' ]]; then
    "$HOME/bin/scripts/input-lang-en"
  elif [[ "$1" == '--opt2' ]]; then
    "$HOME/bin/scripts/input-lang-de"
  elif [[ "$1" == '--opt3' ]]; then
    "$HOME/bin/scripts/input-lang-zh"
  fi
}

# Actions
chosen="$(run_rofi)"
case ${chosen} in
$option_1)
  run_cmd --opt1
  ;;
$option_2)
  run_cmd --opt2
  ;;
$option_3)
  run_cmd --opt3
  ;;
'')
  # Escape / empty selection -- do nothing
  ;;
*)
  notify-send -t 1500 "Input Language" "'$chosen' isn't en/de/zh"
  ;;
esac
