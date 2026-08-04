# Rofi config

`config.rasi` is a small hand-written theme used as the fallback when rofi
is launched without an explicit `-theme` flag (e.g. `rofi -show window`).

## Launcher theme

The `Super+Space` app launcher (see
[pop-shell-setup.md](../pop-shell/pop-shell-setup.md)) uses a prebuilt
theme from [adi1090x/rofi](https://github.com/adi1090x/rofi):

- `launchers/type-2/style-3.rasi` — the active style. Centered box, colors
  via `shared/colors.rasi` → `colors/catppuccin.rasi`, font set to
  `Hack Nerd Font 10` (the Nerd Font actually installed on this system;
  upstream defaults to Iosevka).
  - Upstream's `style-3.rasi` only sets `modi: "drun"` and has no
    `mode-switcher` widget in its layout, so out of the box it's app
    search only. `modi` was changed in place to
    `"drun,run,filebrowser,window"` so `Ctrl+Tab` / `Ctrl+Shift+Tab`
    still cycles into `run`, file-browser, and window search — there's
    just no visible button for it (unlike type-6, which renders a
    clickable APPS/RUN/FILES/WINDOW switcher).
- `launchers/type-3/` and `launchers/type-6/` — earlier styles kept
  around as alternatives (`type-3/style-10.rasi`: same centered-box family
  as type-2; `type-6/style-5.rasi`: sidebar-image layout with a visible
  mode-switcher, uses `images/e.jpg`); neither is currently wired to the
  keybinding.
- `colors/` — adi1090x's full color-scheme pack (`nord`, `dracula`,
  `gruvbox`, `tokyonight`, ...), used by `shared/colors.rasi`-style themes
  (type-2, type-3). type-6 defines colors inline instead.
- Only `type-2`, `type-3`, and `type-6` have been pulled in so far. The
  [adi1090x/rofi](https://github.com/adi1090x/rofi) repo has 7 launcher
  types (each with several `style-N.rasi` variants); browse its
  README/previews to see them.

### Switching style or color

1. Pick a different `style-N.rasi` inside `launchers/type-2/` (or
   `type-3/`, `type-6/`), or copy another `type-X/` directory out of a
   fresh clone of `adi1090x/rofi` into `launchers/`.
2. Update the `-theme` path in the `Super+Space` custom keybinding
   (`gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:.../custom1/ command '...'`,
   also update it in `pop-shell/.config/pop-shell/setup-pop-shell` so it
   persists across reinstalls).
3. To change the color scheme: for `shared/colors.rasi`-style themes
   (type-2, type-3), edit the `@import` in `launchers/type-X/shared/colors.rasi`
   to point at a different file in `colors/`. For self-contained themes
   like type-6 (no `shared/`), edit the `background`/`foreground`/
   `selected`/etc. values directly in the `* { ... }` block near the top
   of the `style-N.rasi` file.
4. If a `style-N.rasi` you switch to only sets `modi: "drun"` and you want
   window/file search too, add `,run,filebrowser,window` to its `modi`
   line — `Ctrl+Tab` will cycle modes even without a visible switcher
   button.

## Quicklinks (`Super+Shift+Space`)

`applets/bin/quicklinks.sh` is adi1090x/rofi's bookmark-menu applet — a
`-dmenu` list of websites that opens the pick with `xdg-open`. Defaults to
Google, Gmail, YouTube, GitHub, Reddit, Twitter.

- Edit the `option_N` / `run_cmd()` pairs in `applets/bin/quicklinks.sh` to
  change the links.
- `applets/shared/theme.bash` picks the applet theme (`type-1/style-1.rasi`
  by default) shared by all applet scripts, not just quicklinks; only
  `type-1` has been pulled in from adi1090x/rofi so far (it has 5, each
  with a few styles).
- `applets/shared/colors.rasi` / `fonts.rasi` — same pattern as the
  launcher: colors via `colors/catppuccin.rasi`, font `Hack Nerd Font`.
  `quicklinks.sh` itself also hardcodes an `efonts` variable for the
  option text size — keep it in sync with `shared/fonts.rasi` if you
  change fonts.
- `-normal-window` was added to `quicklinks.sh`'s `rofi_cmd()` for the
  same Wayland keyboard-focus reason as the main launcher (see
  [pop-shell-setup.md](../pop-shell/pop-shell-setup.md)); don't remove it.

## Global file search (`Super+Shift+F`)

`scripts/rofi-find.sh` is a small [rofi script
mode](https://man.archlinux.org/man/rofi-script.5) — not from
adi1090x/rofi, written for this repo. rofi's own `-show filebrowser`
only lists one directory at a time; this instead dumps every file under
`$HOME` up front (via `locate` if installed, `find` otherwise) so rofi's
built-in fuzzy filter can match across the whole tree as you type, no
need to navigate into subdirs. Selecting a result opens it with
`xdg-open`.

Install `plocate` (`sudo apt install plocate`) for instant, indexed
results — without it, the script falls back to a live `find` that takes
a few seconds on a large home directory.
