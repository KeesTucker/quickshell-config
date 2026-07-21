import QtQuick
import Quickshell.Io
import "../" as Root

ModuleButton {
    id: root

    property var command: []
    property int pollInterval: 2000
    property color activeColor: "#a55555"
    property bool active: false

    textColor: active ? activeColor : Root.Theme.foreground
    fontSize: 13

    Process {
        id: proc
        command: root.command
        stdout: SplitParser {
            onRead: line => {
                if (!line || !line.trim()) return;
                try {
                    const data = JSON.parse(line);
                    root.text = data.text ?? "";
                    root.tooltipText = data.tooltip ?? "";
                    root.active = data.class === "active";
                } catch (e) {
                    // ignore malformed output
                }
            }
        }
    }

    Timer {
        interval: root.pollInterval
        running: root.command.length > 0
        repeat: true
        triggeredOnStart: true
        onTriggered: proc.running = true
    }
}
