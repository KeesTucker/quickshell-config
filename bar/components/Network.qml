import QtQuick
import Quickshell
import Quickshell.Io
import "../" as Root

ModuleButton {
    id: root

    readonly property var wifiIcons: ["󰤯", "󰤟", "󰤢", "󰤥", "󰤨"]

    text: ""
    fontSize: 13

    Process {
        id: proc
        command: ["omarchy-bar-network-status"]
        stdout: SplitParser {
            onRead: line => {
                if (!line || !line.trim()) return;
                try {
                    const data = JSON.parse(line);
                    if (data.state === "wifi") {
                        const idx = Math.max(0, Math.min(4, Math.floor(data.signal / 21)));
                        root.text = root.wifiIcons[idx];
                        root.tooltipText = data.essid;
                    } else if (data.state === "ethernet") {
                        root.text = "󰀂";
                        root.tooltipText = "Connected";
                    } else {
                        root.text = "󰤮";
                        root.tooltipText = "Disconnected";
                    }
                } catch (e) {
                    // ignore malformed output
                }
            }
        }
    }

    Timer {
        interval: 3000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: proc.running = true
    }

    onClicked: Quickshell.execDetached(["omarchy-launch-wifi"])
}
