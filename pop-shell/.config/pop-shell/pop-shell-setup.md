# Pop Shell setup (Ubuntu / GNOME)

Pop Shell is System76's tiling-window-manager extension for GNOME Shell. This
repo assumes you're running it on stock Ubuntu (not Pop!_OS), which means it
has to be installed manually.

## Quick start

```
git clone git@github.com/CarstenOtl/dotfiles_endeavor_1.git
cd dotfiles_endeavor_1
stow pop-shell rofi
./bin/bin/scripts/setup-pop-shell   # or: ~/bin/scripts/setup-pop-shell after stowing `bin`
```

Log out and back in once it finishes, so GNOME Shell picks up the newly
enabled/disabled extensions.

## What `setup-pop-shell` does

1. Builds and installs Pop Shell from source (`github.com/pop-os/shell`,
   `make local-install`) if it isn't already installed. Requires `git`,
   `make`, `nodejs`, `npm`.
2. Enables the `pop-shell@system76.com` extension.
3. Disables extensions that fight with Pop Shell's tiling and keybindings:
   - `tiling-assistant@ubuntu.com` — Ubuntu's own built-in tiling extension,
     binds overlapping Super+arrow-style shortcuts.
   - `ding@rastersoft.com` — desktop icons. Not a functional conflict, but
     its icon layer can render on top of windows Pop Shell sends to the
     background. Disabled for a cleaner desktop.
4. Sets a fixed 8-workspace layout (`dynamic-workspaces off`,
   `num-workspaces 8`) and centers new floating windows
   (`center-new-windows true`) — the latter matters because rofi (below)
   runs in a mode that hands window placement to Mutter.
5. Binds workspace switch/move to `Super+1..8` / `Super+Shift+1..8`.
6. Frees `Super+Space` from GNOME's input-source switcher so rofi can use it.
7. Registers a custom launcher shortcut for rofi (table below).

After the script, run `stow pop-shell rofi` from the repo root (if you
haven't already) to symlink in:
- `pop-shell/.config/pop-shell/config.json` — floating-window exceptions
  (includes `Rofi`, so its launcher window never gets auto-tiled).
- `rofi/.config/rofi/` — rofi themes and `config.rasi`.

## Why rofi needs `-normal-window`

Under Wayland, rofi (an X11 app running via XWayland) creates its launcher
as an override-redirect popup by default. Mutter frequently fails to hand
keyboard focus to override-redirect XWayland windows, especially when
spawned from a keybinding rather than a terminal — the window appears but
never receives input, and only `kill` gets rid of it.

`rofi -show drun -normal-window` makes rofi request a normal, managed
window instead, so Mutter focuses it the same way it focuses any other
app window. The tradeoff: rofi's own self-centering logic is disabled in
this mode, so `org.gnome.mutter center-new-windows` is turned on to
compensate (this affects all new floating windows, not just rofi).

The `Rofi` entry in `pop-shell/config.json`'s floating exceptions keeps
Pop Shell's auto-tiler from grabbing the (now normal) rofi window whenever
it resizes as you type.

## Keybinding reference

### Pop Shell (built into the extension, not scripted here)

| Shortcut | Action |
|---|---|
| `Super+/` | Open Pop Shell's own launcher |
| `Super+Y` | Toggle tiling mode |
| `Super+G` | Toggle floating for focused window |
| `Super+R` | Enter tile-adjustment mode (arrows to move, Enter/Escape to accept/reject) |
| `Super+arrows` / `Super+h,j,k,l` | Move focus between tiled windows |
| `Ctrl+Super+arrows` / `h,j,k,l` | Swap tiled windows |
| `Shift+arrows` (in tile-adjust mode) | Resize |
| `Super+S` | Toggle window stacking |
| `Ctrl+Shift+Super+arrows` | Move focused window to adjacent workspace |
| `Shift+Super+left/right` | Move focused window to adjacent monitor |

### Workspaces (scripted)

| Shortcut | Action |
|---|---|
| `Super+1` .. `Super+8` | Switch to workspace 1-8 |
| `Super+Shift+1` .. `Super+Shift+8` | Move focused window to workspace 1-8 |

### App launchers (scripted, custom media-keys)

| Shortcut | Command |
|---|---|
| `Super+Space` | `rofi -show drun -normal-window` |

### Other GNOME defaults relevant here

| Shortcut | Action |
|---|---|
| `Shift+Super+Q` | Close window |
| `Super+Comma` | Minimize |
| `Super+M` | Toggle maximize |
| `Super+Tab` / `Shift+Super+Tab` | Switch applications |

## Troubleshooting

- **rofi window opens but ignores all input, only `kill` closes it** — you're
  missing `-normal-window`; see above.
- **rofi flickers between floating and tiled as you type** — the `Rofi`
  floating exception in `pop-shell/config.json` isn't applied (GNOME Shell
  needs a restart/relogin to pick up extension-adjacent config changes), or
  rofi is running under a different WM_CLASS than `Rofi` (check your rofi
  config for a `-class`/`-name` override).
- **`ding@rastersoft.com` desktop icons come back after being disabled** — it
  can silently re-enable itself; re-run `setup-pop-shell` or
  `gnome-extensions disable ding@rastersoft.com` directly.
- **Super+arrow shortcuts do the wrong thing** — check
  `gnome-extensions list --enabled` for `tiling-assistant@ubuntu.com`; if
  it's back on, disable it again.
