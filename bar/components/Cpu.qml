import Quickshell
import "../" as Root

ModuleButton {
    text: "󰍛"

    onClicked: Quickshell.execDetached(["omarchy-launch-or-focus-tui", "btop"])
    onRightClicked: Quickshell.execDetached(["alacritty"])
}
