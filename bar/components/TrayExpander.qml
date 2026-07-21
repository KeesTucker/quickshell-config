import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell.Services.SystemTray
import "../" as Root

RowLayout {
    id: root
    spacing: 10

    property bool expanded: false

    Text {
        text: ""
        color: Root.Theme.foreground
        font.family: Root.Theme.monoFont
        font.pixelSize: 13
        rotation: root.expanded ? 180 : 0

        Behavior on rotation {
            NumberAnimation { duration: 150 }
        }

        MouseArea {
            anchors.fill: parent
            anchors.margins: -4
            onClicked: root.expanded = !root.expanded
        }
    }

    Repeater {
        model: root.expanded ? SystemTray.items : []

        Item {
            required property var modelData
            implicitWidth: 12
            implicitHeight: Root.Theme.barHeight

            Image {
                anchors.centerIn: parent
                width: 12
                height: 12
                source: modelData.icon
                sourceSize: Qt.size(12, 12)
            }

            MouseArea {
                anchors.fill: parent
                acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
                hoverEnabled: true
                onClicked: mouse => {
                    if (mouse.button === Qt.LeftButton) modelData.activate();
                    else modelData.secondaryActivate();
                }
                onWheel: wheel => modelData.scroll(wheel.angleDelta.y, false)

                ToolTip.visible: containsMouse && (modelData.tooltipTitle.length > 0)
                ToolTip.text: modelData.tooltipTitle
            }
        }
    }
}
