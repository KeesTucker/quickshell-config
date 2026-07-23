# quickshell-config

Quickshell bar for Hyprland (Omarchy-based setup).

The whole visible frame — top bar, side/bottom borders — is drawn as **one**
fullscreen, non-exclusive layer surface with a single canvas path (an outer
box flush against the screen edges with a rounded-rect hole punched out for
window content). That's deliberate: it gives
[hyprglass](https://github.com/KeesTucker/hyprglass) exactly one content box
and one JFA distance field to compute glass for, instead of several
independently-glassed surfaces that could show seams where they meet. See
`bar/Frame.qml` and `bar/components/Reservation.qml` (per-edge tiling-space
reservation, since a single surface can't use `exclusiveZone` per edge on
its own).

`bar/Theme.qml` mirrors a few values from `hypr/looknfeel.conf` (rounding,
rounding_power, gaps_out) so the frame's cutout curve matches the actual
window corner.

## Installing on Omarchy (replacing waybar)

1. Install Quickshell: `omarchy pkg add quickshell` (needs an interactive
   sudo password, so run it yourself in a terminal rather than through an
   agent).
2. Clone this repo, then link `bar/` into Quickshell's config search path
   so it resolves as the `quickshell-config` config
   (`quickshell -c quickshell-config` / `quickshell.detects
   <xdg-config>/quickshell/<name>/shell.qml`):
   ```bash
   mkdir -p ~/.config/quickshell
   ln -sfn ~/projects/quickshell-config/bar ~/.config/quickshell/quickshell-config
   ```
3. Disable waybar via Omarchy's existing toggle (the default
   `~/.local/share/omarchy/default/hypr/autostart.conf` only launches
   waybar when the `waybar-off` flag is absent, so no need to edit any
   default/read-only files):
   ```bash
   omarchy toggle waybar
   ```
4. Add a Quickshell autostart line in `~/.config/hypr/autostart.conf`
   (user-editable, sourced after the defaults):
   ```
   exec-once = uwsm-app -- quickshell -c quickshell-config
   ```
5. `hyprctl reload` picks up the config change; run
   `setsid uwsm-app -- quickshell -c quickshell-config &` once by hand (or
   just log out/in) to start it for the current session, since
   `exec-once` only fires on Hyprland's initial launch.
6. Sanity-check with `hyprctl layers` (look for the `omarchy-frame` /
   `omarchy-reserve` namespaces on each monitor) and `hyprctl
   configerrors`.

### `omarchy-bar-network-status` helper

`bar/components/Network.qml` shells out to `omarchy-bar-network-status`
(one-shot, polled every 3s by the component's own `Timer` — not a
long-running daemon). Omarchy doesn't ship this script itself (waybar's
stock config used waybar's built-in `network` module instead), so it
lives in this repo at `bin/omarchy-bar-network-status`, built on `nmcli`
(works regardless of whether the wifi backend is NetworkManager's own or
iwd underneath, since `nmcli` is the front end either way) and `jq` for
safe JSON output. It prints one line matching the contract `Network.qml`
expects:
```json
{"state": "ethernet"}
{"state": "wifi", "signal": 0-100, "essid": "..."}
{"state": "disconnected"}
```
Symlink it onto `PATH` alongside the `bar/` link:
```bash
ln -sfn ~/projects/quickshell-config/bin/omarchy-bar-network-status ~/.local/bin/omarchy-bar-network-status
```
Note: Quickshell's `Process` element appears to cache a failed binary
lookup for the life of the shell instance — if you add/fix this script
while quickshell is already running, restart it (`quickshell kill -c
quickshell-config`, relaunch) rather than expecting the next poll to pick
it up.

To revert to waybar: `omarchy toggle waybar` again, and remove/comment
the `quickshell -c quickshell-config` `exec-once` line above.
