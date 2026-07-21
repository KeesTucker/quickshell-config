import Quickshell
import Quickshell.Services.UPower
import "../" as Root

ModuleButton {
    id: root

    readonly property var device: UPower.displayDevice
    readonly property bool present: device && device.isPresent
    readonly property real pct: present ? device.percentage : 0
    readonly property bool charging: present && device.state === UPowerDeviceState.Charging
    readonly property bool full: present && device.state === UPowerDeviceState.FullyCharged

    readonly property var chargingIcons: ["󰢜", "󰂆", "󰂇", "󰂈", "󰢝", "󰂉", "󰢞", "󰂊", "󰂋", "󰂅"]
    readonly property var defaultIcons: ["󰁺", "󰁻", "󰁼", "󰁽", "󰁾", "󰁿", "󰂀", "󰂁", "󰂂", "󰁹"]

    text: {
        if (!present) return "";
        if (full) return "󰂅";
        const idx = Math.max(0, Math.min(9, Math.floor(pct / 10)));
        return charging ? chargingIcons[idx] : defaultIcons[idx];
    }

    tooltipText: {
        if (!present) return "";
        const watts = Math.abs(device.changeRate).toFixed(0);
        return charging
            ? watts + "W↑ " + Math.round(pct) + "%"
            : watts + "W↓ " + Math.round(pct) + "%";
    }

    onClicked: Quickshell.execDetached(["omarchy-menu", "power"])
    onRightClicked: Quickshell.execDetached(["bash", "-c", "notify-send -u low \"$(omarchy-battery-status)\""])
}
