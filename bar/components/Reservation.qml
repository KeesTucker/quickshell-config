import QtQuick
import Quickshell
import Quickshell.Wayland
import "../" as Root

// Invisible, content-free layer surface whose only job is to reserve screen
// space on one edge so Hyprland tiles windows around the frame. wlr-layer-
// shell's exclusiveZone is a single scalar tied to one anchor edge - a
// single surface can't reserve different amounts on 4 different edges - so
// reservation is split out from drawing entirely: Frame.qml (one fullscreen,
// non-exclusive surface) draws the whole visible frame as one path, and
// these four tiny surfaces (one per edge) do nothing but reserve the gap.
PanelWindow {
    id: reservation

    required property var modelData
    property string edge: "top" // "top", "bottom", "left", "right"
    property int amount: 0

    screen: modelData
    color: "transparent"

    anchors {
        top: edge !== "bottom"
        bottom: edge !== "top"
        left: edge !== "right"
        right: edge !== "left"
    }

    // The axis not spanned by this edge's own anchor pair is fully
    // determined by the opposing anchors (e.g. "top" is anchored left+right,
    // so implicitWidth is never actually used) - harmless to set both.
    implicitWidth: amount
    implicitHeight: amount
    exclusiveZone: amount

    WlrLayershell.layer: WlrLayer.Top
    WlrLayershell.namespace: "omarchy-reserve"

    // Purely a space reservation, no visible or interactive content - must
    // never intercept clicks/scroll meant for Frame's buttons or the
    // windows tiled around it. Empty mask = zero-area accepted region = the
    // whole surface is click-through.
    mask: Region {}
}
