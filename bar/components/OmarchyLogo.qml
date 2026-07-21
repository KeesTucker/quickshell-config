import Quickshell
import "../" as Root

ModuleButton {
    text: ""
    fontFamily: Root.Theme.iconFont
    fontSize: 16
    tooltipText: "Omarchy Menu\n\nSuper + Alt + Space"

    onClicked: Quickshell.execDetached(["omarchy-menu"])
    onRightClicked: Quickshell.execDetached(["xdg-terminal-exec"])
}
