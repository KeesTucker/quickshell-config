import Quickshell
import "../" as Root

PolledJsonIndicator {
    command: [Quickshell.env("OMARCHY_PATH") + "/default/waybar/weather.sh"]
    pollInterval: 60000
    activeColor: Root.Theme.foreground

    onClicked: Quickshell.execDetached(["bash", "-c", "notify-send -u low \"$(omarchy-weather-status)\""])
}
