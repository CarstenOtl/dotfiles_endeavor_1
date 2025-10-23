#!/usr/bin/env bash
# Detect connected displays by EDID and assign stable aliases

mapfile=~/dotfiles/bin/bin/scripts/monitor-map.conf
#declare -A ALIAS
#while read -r prefix name; do
#  [[ -z "$prefix" || "$prefix" == \#* ]] && continue
#  ALIAS[$prefix]=$name
#done <"$mapfile"
#
#for sysfile in /sys/class/drm/*/edid; do
#  [[ -r "$sysfile" ]] || continue
#  edid=$(hexdump -v -e '/1 "%02x"' "$sysfile")
#  [[ -z "$edid" ]] && continue
#  name=$(basename "$(dirname "$sysfile")") # e.g. card0-DP-1
#  prefix=${edid:0:24}
#  for match in "${!ALIAS[@]}"; do
#    if [[ $edid == $match* ]]; then
#      # Find xrandr name that contains same connector
#      xname=$(xrandr --query | grep "^${name##*-}" | cut -d" " -f1 | head -n1)
#      [[ -z "$xname" ]] && xname="$name"
#      echo "export MON_${ALIAS[$match]}=$xname"
#    fi
#  done

# Get EDIDs directly from xrandr (not from /sys)
declare -A EDID_MAP

# Your known EDIDs
EDID_MAP["00ffffffffffff0010ac40424c4242480f1f0104a53c22783ac525aa534f9d25105054a54b00714f8180a9c0d1c081c081cf01010101023a801871382d40582c450056502100001e000000ff00433632315338330a2020202020000000fc0044454c4c205032373232480a20000000fd00384c1e5311010a2020202020200067"]="MON_MIDDLE"
EDID_MAP["00ffffffffffff0010ac40424252424424200104a53c22783ac525aa534f9d25105054a54b00714f8180a9c0d1c081c081cf01010101023a801871382d40582c450056502100001e000000ff004a324246594e330a2020202020000000fc0044454c4c205032373232480a20000000fd00384c1e5311010a202020202020000b"]="MON_RIGHT"
EDID_MAP["00ffffffffffff0006afa0eb00000000331f0104b522167803b045a754499c210f505400000001010101010101010101010101010101786e00a0a04084603020aa0058d710000018000000fd0c30a51f1f4e010a202020202020000000fe0041554f0a202020202020202020000000fe004231363051414e30332e48200a02b502031d00e3058000e60607016b6b476d1a0000020330a500046b476b4700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000009c7013790000030114b62f0185ff099f002f001f003f0683000900090000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000002290"]="MON_INTERNAL"

# Loop through XRandR outputs and detect by EDID
for output in $(xrandr | awk '/ connected/{print $1}'); do
  edid=$(xrandr --prop | awk -v out="$output" '
        $0 ~ "^"out" " {found=1}
        found && /EDID:/ {getline; while ($0 ~ /^[[:space:]]*[0-9a-fA-F]+$/) {printf "%s", $1; getline}; found=0}
    ')
  if [ -n "$edid" ]; then
    varname=${EDID_MAP["$edid"]}
    [ -n "$varname" ] && eval "export $varname=$output"
  fi
done

# Internal display (laptop)
export MON_INTERNAL=$(xrandr | awk '/ connected/ && /eDP|LVDS/{print $1; exit}')

# Sanity check
echo "MON_INTERNAL=$MON_INTERNAL"
echo "MON_MIDDLE=$MON_MIDDLE"
echo "MON_RIGHT=$MON_RIGHT"
