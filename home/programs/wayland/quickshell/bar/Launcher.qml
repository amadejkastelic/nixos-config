import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Widgets
import qs.components
import qs.utils

WrapperMouseArea {
    id: root

    Layout.fillHeight: true
    implicitWidth: height

    Process {
        id: launcher
        command: ["vicinae", "toggle"]
    }

    onClicked: {
        launcher.running = true;
    }

    Rectangle {
        id: launcherBg
        anchors.centerIn: parent
        implicitWidth: parent.height * 0.4
        implicitHeight: parent.height * 0.4
        radius: height / 2
        color: root.containsMouse ? Colors.accent : "transparent"

        Behavior on color {
            ColorAnimation { duration: 200 }
        }

        Text {
            anchors.centerIn: parent
            text: "󱄅"
            font.family: "Symbols Nerd Font"
            font.pixelSize: parent.height * 0.5
            color: root.containsMouse ? Colors.crust : Colors.foreground

            Behavior on color {
                ColorAnimation { duration: 200 }
            }
        }
    }
}
