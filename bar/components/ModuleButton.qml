import QtQuick
import QtQuick.Controls
import "../" as Root

Item {
    id: root

    property string text: ""
    property string tooltipText: ""
    property string fontFamily: Root.Theme.monoFont
    property real fontSize: 14
    property color textColor: Root.Theme.foreground

    signal clicked()
    signal rightClicked()
    signal wheelUp()
    signal wheelDown()

    implicitWidth: root.text.length > 0 ? label.implicitWidth + 12 : 0
    implicitHeight: Root.Theme.barHeight

    Text {
        id: label
        anchors.centerIn: parent
        text: root.text
        color: root.textColor
        font.family: root.fontFamily
        font.pixelSize: root.fontSize
        renderType: Text.NativeRendering
    }

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        hoverEnabled: true
        onClicked: mouse => {
            if (mouse.button === Qt.RightButton) root.rightClicked();
            else root.clicked();
        }
        onWheel: wheel => {
            if (wheel.angleDelta.y > 0) root.wheelUp();
            else if (wheel.angleDelta.y < 0) root.wheelDown();
        }

        ToolTip.visible: root.tooltipText.length > 0 && containsMouse
        ToolTip.text: root.tooltipText
        ToolTip.delay: 400
    }
}
