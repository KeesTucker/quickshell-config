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
