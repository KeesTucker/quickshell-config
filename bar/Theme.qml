pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    readonly property int barHeight: 44
    // cornerRadius tracks hypr/looknfeel.conf's `rounding` plus the diagonal
    // of `gaps_out` (gaps_out * sqrt(2)) - the same relationship that gives
    // rounding its own value from gaps_out in the first place (10 * sqrt(2)
    // ~= 14.14 ~= rounding = 14), extended outward by one more gap-diagonal
    // so the cutout curve clears the window's actual rendered corner.
    // cornerPower tracks `rounding_power` directly (1:1, no offset needed).
    property int hyprRounding: 14
    property real hyprRoundingPower: 4
    property real hyprGapsOut: 10
    readonly property int cornerRadius: Math.round(hyprRounding + hyprGapsOut * Math.SQRT2)
    readonly property real cornerPower: hyprRoundingPower
    readonly property int frameThickness: 16
    readonly property real barAlpha: 0.65

    readonly property string monoFont: "JetBrainsMono Nerd Font"
    readonly property string iconFont: "omarchy"

    property color accent: "#7daea3"
    property color foreground: "#d4be98"
    property color background: "#282828"
    property var palette: ({})

    readonly property color barBackground: Qt.rgba(background.r, background.g, background.b, barAlpha)

    function reparse() {
        const text = colorsFile.text();
        const next = {};
        const lineRe = /^(\w+)\s*=\s*"([^"]+)"/;
        for (const line of text.split("\n")) {
            const m = lineRe.exec(line.trim());
            if (!m) continue;
            next[m[1]] = m[2];
        }
        if (next.accent) accent = next.accent;
        if (next.foreground) foreground = next.foreground;
        if (next.background) background = next.background;
        palette = next;
    }

    FileView {
        id: colorsFile
        path: `${Quickshell.env("HOME")}/.config/omarchy/current/theme/colors.toml`
        watchChanges: true
        onFileChanged: reload()
        onLoaded: root.reparse()
    }

    function reparseLooknfeel() {
        const text = looknfeelFile.text();
        const roundingMatch = /^\s*rounding\s*=\s*(\d+)/m.exec(text);
        if (roundingMatch) hyprRounding = parseInt(roundingMatch[1], 10);
        const powerMatch = /^\s*rounding_power\s*=\s*([\d.]+)/m.exec(text);
        if (powerMatch) hyprRoundingPower = parseFloat(powerMatch[1]);
        const gapsOutMatch = /^\s*gaps_out\s*=\s*([\d.]+)/m.exec(text);
        if (gapsOutMatch) hyprGapsOut = parseFloat(gapsOutMatch[1]);
    }

    FileView {
        id: looknfeelFile
        path: `${Quickshell.env("HOME")}/.config/hypr/looknfeel.conf`
        watchChanges: true
        onFileChanged: reload()
        onLoaded: root.reparseLooknfeel()
    }
}
