import QtQuick
import Quickshell
import Quickshell.Io
import "../" as Root

ModuleButton {
    id: root

    readonly property string icon: ""

    text: ""
    tooltipText: "Omarchy update available"

    Process {
        id: proc
        command: ["omarchy-update-available"]
        onExited: exitCode => root.text = exitCode === 0 ? root.icon : ""
    }

    Timer {
        interval: 21600000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: proc.running = true
    }

    onClicked: Quickshell.execDetached(["omarchy-launch-floating-terminal-with-presentation", "omarchy-update"])
}
