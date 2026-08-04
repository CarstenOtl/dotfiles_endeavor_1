# Rofi config

`config.rasi` is a small hand-written theme used as the fallback when rofi
is launched without an explicit `-theme` flag (e.g. `rofi -show window`).

## Launcher theme

The `Super+Space` app launcher (see
[pop-shell-setup.md](../pop-shell/pop-shell-setup.md)) uses a prebuilt
theme from [adi1090x/rofi](https://github.com/adi1090x/rofi) instead:

- `launchers/type-3/style-10.rasi` — the active style.
- `launchers/type-3/shared/colors.rasi` — imports `colors/catppuccin.rasi`
  (edited from upstream's default `onedark.rasi` to match this repo's
  existing color scheme).
- `launchers/type-3/shared/fonts.rasi` — set to `Hack Nerd Font 10` (the
  Nerd Font actually installed on this system; upstream defaults to
  Iosevka).
- `colors/` — the rest of adi1090x's color schemes (`nord`, `dracula`,
  `gruvbox`, `tokyonight`, ...), kept around in case you want to switch.
- `launchers/type-*/` — only `type-3` was pulled in. The
  [adi1090x/rofi](https://github.com/adi1090x/rofi) repo has 7 launcher
  types and a `style-1` .. `style-15` variant within `type-3` alone; browse
  its README/previews to see them.

### Switching style or color

1. Pick a different `style-N.rasi` inside `launchers/type-3/`, or copy
   another `type-X/` directory out of a fresh clone of
   `adi1090x/rofi` into `launchers/`.
2. Update the `-theme` path in the `Super+Space` custom keybinding
   (`gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:.../custom1/ command '...'`,
   also update it in `pop-shell/.config/pop-shell/setup-pop-shell` so it
   persists across reinstalls).
3. To change the color scheme instead of the layout, edit the `@import` in
   `launchers/type-3/shared/colors.rasi` to point at a different file in
   `colors/`.
