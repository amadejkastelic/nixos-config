import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import qs.utils

PanelWindow {
    id: barWindow
    WlrLayershell.namespace: "quickshell:bar"
    screen: Config.preferredMonitor

    anchors {
        top: true
    }

    WlrLayershell.margins {
        top: Config.padding
    }

    WlrLayershell.exclusiveZone: Config.barHeight

    implicitHeight: Config.barHeight
    implicitWidth: screen?.width ?? 1920

    color: "transparent"

    Rectangle {
        id: bar
        anchors.centerIn: parent
        width: parent.width * 0.5
        height: parent.height
        radius: Config.radius

        color: Colors.bgBar

        // left
        RowLayout {
            id: barLeft

            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.top: parent.top

            anchors.leftMargin: Config.spacing
            anchors.rightMargin: Config.spacing
            spacing: Config.spacing

            Launcher {}
            Workspaces {}
        }

        // middle
        RowLayout {
            id: barMiddle

            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top

            anchors.leftMargin: Config.spacing
            anchors.rightMargin: Config.spacing
            spacing: Config.spacing

            MediaPlayer {}
        }

        // right
        RowLayout {
            id: barRight

            anchors.bottom: parent.bottom
            anchors.right: parent.right
            anchors.top: parent.top

            anchors.leftMargin: Config.spacing
            anchors.rightMargin: Config.spacing
            spacing: Config.spacing

            Tray {}
            Resources {}
            NightLight {}
            Clock {}
        }
    }
}
