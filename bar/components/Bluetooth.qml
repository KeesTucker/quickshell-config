import QtQuick
import Quickshell
import Quickshell.Bluetooth
import "../" as Root

ModuleButton {
    id: root

    readonly property var adapter: Bluetooth.defaultAdapter
    readonly property int connectedCount: {
        if (!adapter) return 0;
        let n = 0;
        for (const d of adapter.devices.values) if (d.connected) n++;
        return n;
    }

    text: {
        if (!adapter) return "";
        if (!adapter.enabled) return "󰂲";
        return connectedCount > 0 ? "󰂱" : "";
    }
    tooltipText: "Devices connected: " + connectedCount

    onClicked: Quickshell.execDetached(["omarchy-launch-bluetooth"])
}
