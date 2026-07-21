import Quickshell
import "../" as Root

PolledJsonIndicator {
    command: [Quickshell.env("OMARCHY_PATH") + "/default/waybar/indicators/idle.sh"]
    pollInterval: 2000

    onClicked: Quickshell.execDetached(["omarchy-toggle-idle"])
}
