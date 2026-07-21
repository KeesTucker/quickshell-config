import Quickshell
import Quickshell.Services.Pipewire
import "../" as Root

ModuleButton {
    id: root

    readonly property var sink: Pipewire.defaultAudioSink
    readonly property var audio: sink ? sink.audio : null
    readonly property real volume: audio ? audio.volume : 0
    readonly property bool muted: audio ? audio.muted : false

    readonly property var levelIcons: ["", "", ""]

    text: {
        if (!audio) return "";
        if (muted) return "";
        const idx = Math.max(0, Math.min(levelIcons.length - 1, Math.floor(volume * levelIcons.length)));
        return levelIcons[idx];
    }
    tooltipText: audio ? "Playing at " + Math.round(volume * 100) + "%" : ""

    onClicked: Quickshell.execDetached(["omarchy-launch-audio"])
    onRightClicked: Quickshell.execDetached(["pamixer", "-t"])
    onWheelUp: if (audio) audio.volume = Math.min(1.0, audio.volume + 0.05)
    onWheelDown: if (audio) audio.volume = Math.max(0.0, audio.volume - 0.05)
}
