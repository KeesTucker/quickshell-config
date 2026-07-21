import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland
import "../" as Root

RowLayout {
    id: root

    property var screen

    spacing: 3

    readonly property var icons: ({
        "1": "1", "2": "2", "3": "3", "4": "4", "5": "5",
        "6": "6", "7": "7", "8": "8", "9": "9", "10": "0"
    })

    readonly property var displayIds: {
        const ids = new Set([1, 2, 3, 4, 5]);
        for (const w of Hyprland.workspaces.values) {
            ids.add(w.id);
        }
        return Array.from(ids).filter(id => id > 0).sort((a, b) => a - b);
    }

    Repeater {
        model: root.displayIds

        Text {
            required property int modelData
            readonly property var ws: {
                for (const w of Hyprland.workspaces.values) {
                    if (w.id === modelData) return w;
                }
                return null;
            }
            readonly property bool active: ws !== null && ws.focused

            text: active ? "󱓻" : (root.icons[String(modelData)] ?? "")
            color: ws === null ? Qt.alpha(Root.Theme.foreground, 0.5) : Root.Theme.foreground
            font.family: Root.Theme.monoFont
            font.pixelSize: 14
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            leftPadding: 6
            rightPadding: 6

            MouseArea {
                anchors.fill: parent
                onClicked: Hyprland.dispatch("workspace " + modelData)
            }
        }
    }
}
