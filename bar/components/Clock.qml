import QtQuick
import Quickshell
import "../" as Root

ModuleButton {
    id: root

    property var now: new Date()

    text: now.toLocaleString(Qt.locale(), "dddd HH:mm")
    tooltipText: ""

    Timer {
        interval: 15000
        running: true
        repeat: true
        onTriggered: root.now = new Date()
    }

    onRightClicked: Quickshell.execDetached(["omarchy-launch-floating-terminal-with-presentation", "omarchy-tz-select"])
}
