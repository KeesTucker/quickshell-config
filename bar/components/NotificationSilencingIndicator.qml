import Quickshell
import "../" as Root

PolledJsonIndicator {
    command: [Quickshell.env("OMARCHY_PATH") + "/default/waybar/indicators/notification-silencing.sh"]
    pollInterval: 2000

    onClicked: Quickshell.execDetached(["omarchy-toggle-notification-silencing"])
}
