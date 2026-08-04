#!/usr/bin/env bash
# rofi script-mode: global file search (rofi's own -show filebrowser only
# lists one directory at a time; this flattens everything under $HOME into
# a single list up front so rofi's fuzzy filter can match across all of it
# as you type, no need to navigate into subdirs first).
#
# Bound to Super+Shift+Space; see pop-shell-setup.md.

set -u

if [ "${ROFI_RETV:-0}" = "1" ] && [ -n "${1:-}" ]; then
    setsid -f xdg-open "$1" >/dev/null 2>&1 < /dev/null
    exit 0
fi

if command -v locate >/dev/null 2>&1; then
    locate -i -- "$HOME/" 2>/dev/null
else
    find "$HOME" -type d \( \
            -path "*/.cache" -o -path "*/.local/share/Trash" \
            -o -path "*/node_modules" -o -path "*/.git" \
            -o -path "*/.npm" -o -path "*/.cargo" -o -path "*/.rustup" \
            -o -path "*/venv" -o -path "*/.venv" -o -path "*/site-packages" \
        \) -prune -o -type f -print 2>/dev/null
fi
