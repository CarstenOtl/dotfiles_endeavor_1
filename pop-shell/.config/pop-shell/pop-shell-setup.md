# Pop Shell setup (Ubuntu / GNOME)

Pop Shell is System76's tiling-window-manager extension for GNOME Shell. This
repo assumes you're running it on stock Ubuntu (not Pop!_OS), which means it
has to be installed manually.

## Quick start

```
git clone git@github.com/CarstenOtl/dotfiles_endeavor_1.git
cd dotfiles_endeavor_1
stow pop-shell rofi
./pop-shell/.config/pop-shell/setup-pop-shell   # or: ~/.config/pop-shell/setup-pop-shell after stowing
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
6. Disables Ubuntu Dock's `Super+1..9` app-hotkeys feature
   (`org.gnome.shell.extensions.dash-to-dock hot-keys`), which otherwise
   steals those same shortcuts to launch/activate the Nth app pinned to
   the dock instead of switching/moving to a workspace.
7. Disables GNOME's native window-tiling and workspace-jump shortcuts that
   overlap with Pop Shell's own keys:
   - `org.gnome.mutter.keybindings toggle-tiled-left/right` (`Super+Left`
     / `Super+Right`) — GNOME's built-in half-screen snap tiling, which
     otherwise steals the same keys Pop Shell uses for tiled-window focus
     movement.
   - `switch-to-workspace-last` / `move-to-workspace-last` (`Super+End`
     / `Super+Shift+End`).
   - `switch-to-workspace-left/right` (`Shift+Super+H` / `Shift+Super+L`)
     — collided with Pop Shell's `pop-monitor-left/right` (move window to
     the adjacent monitor) on the same keys, causing intermittent
     "jumps to the first/last workspace instead of moving the window"
     behavior.
   - `org.gnome.shell.keybindings toggle-quick-settings` (`Super+S`) —
     GNOME's wifi/bluetooth/quick-settings panel, on the same key as Pop
     Shell's `toggle-stacking-global`.
8. Frees `Super+Space` from GNOME's input-source switcher so rofi can use it.
9. Registers custom launcher shortcuts for rofi: the app launcher, a
   quicklinks bookmark menu, and a global file-search menu (table below).
10. Registers three input sources (`org.gnome.desktop.input-sources
    sources`) -- English (xkb `us`), German (xkb `de`), and Chinese Pinyin
    (ibus `libpinyin`) -- so the `input-lang-en/de/zh` scripts (below) have
    something to switch between and GNOME's panel indicator shows the
    right label.

After the script, run `stow pop-shell rofi` from the repo root (if you
haven't already) to symlink in:
- `pop-shell/.config/pop-shell/config.json` — floating-window exceptions
  (includes `Rofi`, so its launcher window never gets auto-tiled).
- `rofi/.config/rofi/` — rofi themes and `config.rasi`, including a
  launcher theme pulled from [adi1090x/rofi](https://github.com/adi1090x/rofi)
  (`launchers/type-2/style-3.rasi`), the same pack's `applets/` quicklinks
  menu, and a `scripts/rofi-find.sh` global file-search script mode; see
  `rofi/.config/rofi/README.md` for how to switch styles or edit the
  quicklinks bookmarks.

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
| `Shift+Super+left/right` / `h,l` | Move focused window to adjacent monitor |

### Workspaces (scripted)

| Shortcut | Action |
|---|---|
| `Super+1` .. `Super+8` | Switch to workspace 1-8 |
| `Super+Shift+1` .. `Super+Shift+8` | Move focused window to workspace 1-8 |

### App launchers (scripted, custom media-keys)

| Shortcut | Command |
|---|---|
| `Super+Space` | `bash -c "PATH=$HOME/bin/scripts:$PATH exec rofi -show drun -theme ~/.config/rofi/launchers/type-2/style-3.rasi -normal-window"` |
| `Super+Shift+Space` | `~/.config/rofi/applets/bin/quicklinks.sh` — bookmark menu (Google, Gmail, YouTube, GitHub, Outlook; unmatched text searches Google instead) |
| `Super+Shift+F` | `rofi -show find -modi "find:~/.config/rofi/scripts/rofi-find.sh" -theme ... -normal-window` — global file search across `$HOME` (no need to browse into subdirs first) |
| `Ctrl+Super+L` | `~/.config/rofi/applets/bin/input-lang.sh` — input language picker (`en`/`de`/`zh`), see below |

### Input language switcher (`Ctrl+Super+L`)

`applets/bin/input-lang.sh` is a quicklinks-style rofi dmenu applet:
`Ctrl+Super+L` pops up a 3-row list (`en`/`de`/`zh`), picking one switches
the active input source immediately. `<Primary><Super>l` was checked
against Pop Shell's own default keybindings (`tile-swap-right` is plain
`<Primary>l`, not `<Primary><Super>l`) and GNOME's `wm.keybindings` /
`mutter.keybindings` / `shell.keybindings` / `media-keys` schemas before
picking it — nothing else claims it.

Each option shells out to one of `input-lang-en/de/zh` (see below) rather
than calling `ibus engine` inline, so there's one place that owns the
engine ids.

#### The underlying scripts

`bin/bin/scripts/input-lang-en/de/zh` (stowed to `~/bin/scripts/`) each
just run `ibus engine <id>` plus a `notify-send` for feedback:

| Command | Switches to |
|---|---|
| `input-lang-en` | English (US) — xkb `us` |
| `input-lang-de` | German — xkb `de` |
| `input-lang-zh` | Chinese (Pinyin) — ibus `libpinyin` |

`ibus engine` (not `setxkbmap` or `gsettings set
org.gnome.desktop.input-sources current N`) is what actually works here:
this is a Wayland session, so Mutter owns the keymap and `setxkbmap` is a
no-op; and while GNOME Shell exposes the active source as
`org.gnome.desktop.input-sources current`, *writing* that key doesn't
trigger a real switch — `gsettings get` after setting it still showed the
old index. `ibus engine <id>` talks straight to the same ibus-daemon
GNOME Shell itself starts (`ibus-daemon --panel disable`) and GNOME
Shell's panel indicator listens for IBus's engine-changed signal, so the
panel label updates correctly too. Chinese has no plain xkb layout the
way English/German do — typing characters needs an IME — hence
`ibus-libpinyin`'s `libpinyin` engine instead of an `xkb:cn` layout.
`setup-pop-shell` registers all three sources
(`org.gnome.desktop.input-sources sources`) so they're known to GNOME
and `ibus engine` can find them by id.

These are also directly runnable: `Super+Space` prepends
`PATH=$HOME/bin/scripts:$PATH` before exec'ing rofi (`~/bin/scripts`
being on `$PATH` in a terminal via `.zshrc`/`.bashrc` isn't enough here —
`Super+Space` is launched by `gnome-settings-daemon` with the graphical
session's environment, which never sources those rc files), so
`Ctrl+Tab`-ing into `run` mode and typing `input-lang-de` still works —
kept as a fallback now that `input-lang.sh` is the normal way to switch.

| Command | Switches to |
|---|---|
| `input-lang-en` | English (US) — xkb `us` |
| `input-lang-de` | German — xkb `de` |
| `input-lang-zh` | Chinese (Pinyin) — ibus `libpinyin` |

Each just runs `ibus engine <id>` plus a `notify-send` for feedback.
`ibus engine` (not `setxkbmap` or `gsettings set
org.gnome.desktop.input-sources current N`) is what actually works here:
this is a Wayland session, so Mutter owns the keymap and `setxkbmap` is a
no-op; and while GNOME Shell exposes the active source as
`org.gnome.desktop.input-sources current`, *writing* that key doesn't
trigger a real switch — `gsettings get` after setting it still showed the
old index. `ibus engine <id>` talks straight to the same ibus-daemon
GNOME Shell itself starts (`ibus-daemon --panel disable`) and GNOME
Shell's panel indicator listens for IBus's engine-changed signal, so the
panel label updates correctly too. Chinese has no plain xkb layout the
way English/German do — typing characters needs an IME — hence
`ibus-libpinyin`'s `libpinyin` engine instead of an `xkb:cn` layout.
`setup-pop-shell` registers all three sources
(`org.gnome.desktop.input-sources sources`) so they're known to GNOME
and `ibus engine` can find them by id.

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
- **rofi's `window` mode doesn't list all open windows** — rofi (like
  `wmctrl`) enumerates windows via X11's `_NET_CLIENT_LIST`, which under
  GNOME Wayland only sees XWayland-backed windows, not native Wayland
  clients. There's no reliable external fix (GNOME Shell's `Eval` D-Bus
  method, the only way to query its real window list, is disabled by
  default). Use Pop Shell's own launcher (`Super+/`) for window search
  instead — it reads Mutter's native window list and sees everything.
- **Super+arrow shortcuts do the wrong thing** — check
  `gnome-extensions list --enabled` for `tiling-assistant@ubuntu.com`; if
  it's back on, disable it again.
- **`Super+Left`/`Super+Right` snap the window to a half-screen instead of
  moving focus** — GNOME's native `toggle-tiled-left`/`toggle-tiled-right`
  mutter keybindings are back on; re-run `setup-pop-shell` or
  `gsettings set org.gnome.mutter.keybindings toggle-tiled-left "[]"`
  (and `toggle-tiled-right`) directly.
- **`Shift+Super+H`/`Shift+Super+L` intermittently jump to the first/last
  workspace instead of moving the window to the adjacent monitor** —
  GNOME's native `switch-to-workspace-left`/`switch-to-workspace-right`
  are bound to the same keys as Pop Shell's `pop-monitor-left/right` and
  race with them; re-run `setup-pop-shell` or
  `gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-left "[]"`
  (and `switch-to-workspace-right`) directly.
- **`Super+Shift+N` sometimes launches/activates an app instead of moving
  the window to workspace N** — Ubuntu Dock's app-hotkeys feature is back
  on and racing with the workspace keybindings for the same `Super+N` /
  `Super+Shift+N` keys; it activates whichever app sits Nth in the dock.
  Fix: `gsettings set org.gnome.shell.extensions.dash-to-dock hot-keys false`.
- **`Super+S` opens GNOME's wifi/bluetooth quick-settings panel instead of
  toggling window stacking** — GNOME's native `toggle-quick-settings` is
  back on the same key as Pop Shell's `toggle-stacking-global`; fix:
  `gsettings set org.gnome.shell.keybindings toggle-quick-settings "[]"`.
