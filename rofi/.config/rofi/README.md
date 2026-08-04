# Rofi config

`config.rasi` is a small hand-written theme used as the fallback when rofi
is launched without an explicit `-theme` flag (e.g. `rofi -show window`).

## Launcher theme

The `Super+Space` app launcher (see
[pop-shell-setup.md](../pop-shell/pop-shell-setup.md)) uses a prebuilt
theme from [adi1090x/rofi](https://github.com/adi1090x/rofi):

- `launchers/type-6/style-5.rasi` — the active style. Sidebar-image layout
  (`imagebox` + `listbox`); colors and font are defined inline in this
  file (type-6 styles don't use `shared/colors.rasi` like type-3 does), so
  the font was changed in place from upstream's `JetBrains Mono Nerd Font`
  to `Hack Nerd Font 10` (the Nerd Font actually installed on this
  system).
- `images/e.jpg` — the sidebar image `style-5.rasi` references
  (`~/.config/rofi/images/e.jpg`). Swap in any image at that path to
  change it; adi1090x/rofi's `files/images/` has more options (`a.png` ..
  `j.jpg`, `flowers-*.png`, `paper.png`, ...).
- `launchers/type-3/` — an earlier style (`style-10`, catppuccin colors via
  `shared/colors.rasi` → `colors/catppuccin.rasi`) kept around as an
  alternative; not currently wired to the keybinding.
- `colors/` — adi1090x's full color-scheme pack (`nord`, `dracula`,
  `gruvbox`, `tokyonight`, ...), only used by `shared/colors.rasi`-style
  themes like type-3.
- Only `type-3` and `type-6` have been pulled in so far. The
  [adi1090x/rofi](https://github.com/adi1090x/rofi) repo has 7 launcher
  types (each with several `style-N.rasi` variants); browse its
  README/previews to see them.

### Switching style or color

1. Pick a different `style-N.rasi` inside `launchers/type-6/` (or
   `type-3/`), or copy another `type-X/` directory out of a fresh clone of
   `adi1090x/rofi` into `launchers/`.
2. Update the `-theme` path in the `Super+Space` custom keybinding
   (`gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:.../custom1/ command '...'`,
   also update it in `pop-shell/.config/pop-shell/setup-pop-shell` so it
   persists across reinstalls).
3. To change the color scheme: for `type-3`-style themes, edit the
   `@import` in `launchers/type-3/shared/colors.rasi` to point at a
   different file in `colors/`. For `type-6`-style themes (self-contained,
   no `shared/`), edit the `background`/`foreground`/`selected`/etc.
   values directly in the `* { ... }` block near the top of the
   `style-N.rasi` file.
