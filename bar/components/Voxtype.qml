import Quickshell
import Quickshell.Io
import "../" as Root

ModuleButton {
    id: root

    readonly property var icons: ({
        "idle": "",
        "recording": "󰍬",
        "transcribing": "󰔟"
    })

    text: ""
    fontSize: 13
    textColor: currentClass === "recording" ? "#a55555" : Root.Theme.foreground

    property string currentClass: "idle"

    Process {
        id: proc
        // omarchy-voxtype-status traps EXIT with `kill 0`, which would nuke
        // this whole shell's process group when the script exits (e.g. it
        // exits immediately if the voxtype binary isn't installed). Give it
        // its own session so that trap can't reach past its own subtree.
        command: ["setsid", "omarchy-voxtype-status"]
        running: true
        stdout: SplitParser {
            onRead: line => {
                if (!line || !line.trim()) return;
                try {
                    const data = JSON.parse(line);
                    root.currentClass = data.class ?? "idle";
                    root.text = root.icons[root.currentClass] ?? "";
                    root.tooltipText = data.tooltip ?? "";
                } catch (e) {
                    // ignore malformed output
                }
            }
        }
    }

    onClicked: Quickshell.execDetached(["omarchy-voxtype-model"])
    onRightClicked: Quickshell.execDetached(["omarchy-voxtype-config"])
}
