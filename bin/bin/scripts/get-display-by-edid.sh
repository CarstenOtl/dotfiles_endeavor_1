for d in $(xrandr --prop | grep " connected" | cut -d" " -f1); do
  echo "$d:"
  xrandr --prop | grep -A12 "^$d" | grep "EDID" -A16 | grep -v "EDID" | tr -d '[:space:]' | tr -d '\n'
  echo -e "\n"
done
