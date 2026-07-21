import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import "./" as Root
import "components" as Components

// The entire visible frame as ONE fullscreen, non-exclusive layer surface
// with ONE Canvas drawing ONE filled path: an outer box flush against the
// screen edges with an inner rounded-rect hole punched out of it (the
// cutout windows render in). This is the only surface hyprglass has to
// compute glass for: one contentBox, one JFA field, no seams between
// independently-glassed surfaces to fall down on (see
// components/Reservation.qml for how window-tiling space still gets
// reserved, since wlr-layer-shell's exclusiveZone can't do that per-edge on
// a single surface).
PanelWindow {
    id: frame

    required property var modelData

    screen: modelData
    color: "transparent"

    anchors {
        top: true
        bottom: true
        left: true
        right: true
    }

    exclusiveZone: -1

    WlrLayershell.layer: WlrLayer.Top
    WlrLayershell.namespace: "omarchy-frame"

    // This surface spans the whole screen, but only the top-bar strip
    // holds interactive content (workspaces, tray, volume, etc.) - the
    // decorative border and the open middle cutout must stay click-through
    // so clicks/scroll reach the window underneath instead of the frame.
    mask: Region {
        x: 0
        y: 0
        width: frame.width
        height: Root.Theme.barHeight
    }

    Canvas {
        id: canvas
        anchors.fill: parent

        property color fillColor: Root.Theme.barBackground
        onFillColorChanged: requestPaint()
        onWidthChanged: requestPaint()
        onHeightChanged: requestPaint()

        // One quarter-turn of a superellipse corner (|x/r|^power + |y/r|^power
        // = 1), sampled as line segments from (cx, cy) + r*(cos, sin) at
        // startAngle to the same at endAngle. power=2 is a plain circular
        // arc; power=4 matches Hyprland's rounding_power "squircle" curve
        // (flatter sides, tighter turn into the corner) so the cutout reads
        // as the same corner shape as the windows sitting in it.
        function squircleCorner(ctx, cx, cy, r, startAngle, endAngle, steps) {
            const exp = 2 / Root.Theme.cornerPower;
            for (let i = 1; i <= steps; i++) {
                const t = startAngle + (endAngle - startAngle) * (i / steps);
                const c = Math.cos(t);
                const s = Math.sin(t);
                const x = cx + r * Math.sign(c) * Math.pow(Math.abs(c), exp);
                const y = cy + r * Math.sign(s) * Math.pow(Math.abs(s), exp);
                ctx.lineTo(x, y);
            }
        }

        onPaint: {
            const ctx = getContext("2d");
            const W = width;
            const H = height;
            const bar = Root.Theme.barHeight;
            const ft = Root.Theme.frameThickness;
            const R = Root.Theme.cornerRadius;
            const steps = 12;

            ctx.reset();
            ctx.clearRect(0, 0, W, H);
            ctx.fillStyle = fillColor;
            ctx.beginPath();

            // Outer box: flush against the screen edges, square corners.
            ctx.rect(0, 0, W, H);

            // Inner box: the squircle cutout where windows render, inset by
            // the frame thickness on each edge (bar height on top). Traced
            // in the opposite rotational direction from the outer rect so
            // the two subpaths wind oppositely - Canvas fill() uses
            // nonzero winding, so opposite winding punches this out as a
            // hole instead of just double-covering it.
            const ix = ft;
            const iy = bar;
            const iw = W - 2 * ft;
            const ih = H - bar - ft;

            ctx.moveTo(ix, iy + R);
            ctx.lineTo(ix, iy + ih - R);
            squircleCorner(ctx, ix + R, iy + ih - R, R, Math.PI, Math.PI / 2, steps);
            ctx.lineTo(ix + iw - R, iy + ih);
            squircleCorner(ctx, ix + iw - R, iy + ih - R, R, Math.PI / 2, 0, steps);
            ctx.lineTo(ix + iw, iy + R);
            squircleCorner(ctx, ix + iw - R, iy + R, R, 0, -Math.PI / 2, steps);
            ctx.lineTo(ix + R, iy);
            squircleCorner(ctx, ix + R, iy + R, R, -Math.PI / 2, -Math.PI, steps);
            ctx.closePath();

            ctx.fill();
        }
    }

    RowLayout {
        anchors.left: parent.left
        anchors.verticalCenter: parent.top
        anchors.verticalCenterOffset: Root.Theme.barHeight / 2
        anchors.leftMargin: 10
        spacing: 12

        Components.OmarchyLogo {}
        Components.Workspaces { screen: frame.modelData }
    }

    RowLayout {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.top
        anchors.verticalCenterOffset: Root.Theme.barHeight / 2
        spacing: 14

        Components.Clock {}
        Components.Weather {}
        Components.UpdateIndicator {}
        Components.Voxtype {}
        Components.ScreenRecordingIndicator {}
        Components.IdleIndicator {}
        Components.NotificationSilencingIndicator {}
    }

    RowLayout {
        anchors.right: parent.right
        anchors.verticalCenter: parent.top
        anchors.verticalCenterOffset: Root.Theme.barHeight / 2
        anchors.rightMargin: 14
        spacing: 14

        Components.TrayExpander {}
        Components.Bluetooth {}
        Components.Network {}
        Components.Volume {}
        Components.Cpu {}
        Components.Battery {}
    }
}
