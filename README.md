# Omarchy shared workspaces

Omarchy 4.5 introduced separate workspace numbers for each monitor. This restores
the shared workspace navigation from Omarchy 4.0.6, while keeping other 4.5 features.

- Every bar shows the same workspace list and focused workspace.
- Selecting a workspace focuses the monitor that owns it.
- Super + 1–0 uses global workspace numbers; Shift moves a window, Shift + Alt moves it silently.
- Super + Tab / Shift + Tab cycles existing workspaces across all monitors.
- Super + Ctrl + Tab returns to the previous workspace across monitors.
- Super + mouse wheel cycles existing workspaces across monitors.
- Monitor hotplug/reload no longer assigns blocks of ten or renumbers workspaces.

This does not switch all monitors together. Existing workspaces 11 and above are
shown with their actual IDs; windows are not automatically merged or renumbered.
The bar retains Omarchy 4.5's workspace layout indicator.

## Install

For Omarchy 4.5's Lua configuration, from a desktop terminal:

```sh
omarchy plugin add https://github.com/OrzSabaku/omarchy-shared-workspaces.git --enable
```

The plugin ID is `sabaku.workspaces`. If that ID already exists as a local clone,
back it up and remove it with `omarchy plugin remove sabaku.workspaces` before
installing this repository. Do not overwrite an existing plugin checkout.

Back up `~/.config/hypr/hyprland.lua`. After the existing bootstrap line, **before**
`require("default.hypr.omarchy")`, add:

```lua
local shared_workspaces = dofile(os.getenv("HOME") .. "/.config/omarchy/plugins/sabaku.workspaces/workspaces.lua")
```

After `require("hypr.bindings")`, add:

```lua
shared_workspaces.bindings()
```

Remove earlier copies of the shared-workspace workaround if present. Keep all
other personal configuration. The shell plugin supplies the bar; these two Lua
lines supply the compositor behavior. Enabling the bar alone is not sufficient.

```sh
hyprctl reload
hyprctl configerrors
```

The bar normally reloads automatically. Use `omarchy restart shell` if necessary.
Do not add this bar-only plugin to `plugins[]`, disable `omarchy.workspaces`
manually, or edit files under `/usr/share/omarchy/`; use `plugin add --enable`.

## Update / remove

```sh
omarchy plugin update sabaku.workspaces
hyprctl reload
```

To return to Omarchy's defaults, first remove both Lua lines and reload Hyprland.
Then restore the stock widget and remove this plugin:

```sh
omarchy plugin enable omarchy.workspaces
omarchy plugin remove sabaku.workspaces
```

Workspace IDs and window placement are not restored from a snapshot. The stock
4.5 configuration may redistribute workspaces when it becomes active again.

## Compatibility and verification

Compared against locally cached Omarchy 4.0.6 and installed Omarchy 4.5.0-3
(Hyprland 0.56.2-4). This overrides internal `o.workspaces` helpers; future Omarchy
versions may need changes. Desktop rendering, hotplug, and keyboard behavior must
be checked in a real session; automated tests do not establish those outcomes.

```sh
omarchy plugin validate .
lua tests/workspaces.lua
node tests/widget.mjs
```

`Workspaces.qml` is derived from Omarchy's MIT-licensed widget. See `LICENSE`.
