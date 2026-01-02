import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.components
import qs.utils

Rectangle {
    id: root

    required property string icon
    required property string label
    required property color accentColor

    signal itemTriggered()

    Layout.fillWidth: true
    implicitHeight: Config.iconSize * 3
    radius: Config.radius
    color: "transparent"
    border.color: "#45475a"
    border.width: 1

    Behavior on color {
        ColorAnimation { duration: 150 }
    }

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: Config.padding * 2
        anchors.rightMargin: Config.padding * 2
        spacing: Config.padding * 2

        MaterialIcon {
            text: root.icon
            font.pointSize: Config.iconSize + 2
            color: root.accentColor
            Layout.alignment: Qt.AlignVCenter
        }

        Text {
            text: root.label
            font.pixelSize: Config.iconSize
            color: "#cdd6f4"
            Layout.alignment: Qt.AlignVCenter
            Layout.fillWidth: true
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        acceptedButtons: Qt.LeftButton
        z: 10

        onClicked: root.itemTriggered()
    }
}
