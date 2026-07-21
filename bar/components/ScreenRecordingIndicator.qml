import Quickshell
import "../" as Root

PolledJsonIndicator {
    command: [Quickshell.env("OMARCHY_PATH") + "/default/waybar/indicators/screen-recording.sh"]
    pollInterval: 2000

    onClicked: Quickshell.execDetached(["omarchy-capture-screenrecording"])
}
