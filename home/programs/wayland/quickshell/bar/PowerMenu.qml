import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import Quickshell.Widgets
import qs.components
import qs.utils

WrapperMouseArea {
    id: root

    Layout.fillHeight: true
    Layout.fillWidth: false
    implicitWidth: height
    Layout.rightMargin: Config.spacing * 0.5

    property bool menuVisible: false

    property real screenCenterOffset: (barWindow.screen?.width ?? 1920) * 0.25
    property real barX: {
        const pos = mapToItem(barRight, 0, 0);
        const rightLayoutX = pos ? pos.x : 0;
        return screenCenterOffset + bar.width - (barRight.width - rightLayoutX);
    }

    Process {
        id: cmdProcess
        command: []
    }

    onClicked: {
        menuVisible = !menuVisible;
    }

    Rectangle {
        id: powerButton
        anchors.centerIn: parent
        implicitWidth: parent.height * 0.6
        implicitHeight: parent.height * 0.6
        radius: height / 2
        color: root.containsMouse || menuVisible ? Colors.accent : "transparent"

        Behavior on color {
            ColorAnimation { duration: 200 }
        }

        Text {
            text: menuVisible ? "󰅖" : "󰐥"
            anchors.centerIn: parent
            font.family: "Symbols Nerd Font"
            font.pixelSize: parent.height * 0.7
            color: root.containsMouse || menuVisible ? Colors.crust : Colors.foreground

            Behavior on color {
                ColorAnimation { duration: 200 }
            }
        }
    }

    PopupMenu {
        id: powerMenu
        anchorWindow: barWindow
        anchorX: root.barX - 10
        anchorY: bar.height + Config.padding
        isVisible: root.menuVisible
        menuWidth: 280
        menuHeight: 150

        onIsVisibleChanged: {
            root.menuVisible = isVisible;
        }

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: Config.padding * 4
            spacing: Config.padding * 3

            GridLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                columns: 2
                columnSpacing: Config.padding * 2
                rowSpacing: Config.padding * 2

                PowerMenuItem {
                    icon: "lock"
                    label: "Lock"
                    accentColor: Colors.blue
                    Layout.column: 0
                    Layout.row: 0
                    onItemTriggered: {
                        cmdProcess.command = ["loginctl", "lock-session"];
                        cmdProcess.running = true;
                        root.menuVisible = false;
                    }
                }

                PowerMenuItem {
                    icon: "power_off"
                    label: "Shutdown"
                    accentColor: Colors.red
                    Layout.column: 0
                    Layout.row: 1
                    onItemTriggered: {
                        cmdProcess.command = ["systemctl", "poweroff"];
                        cmdProcess.running = true;
                        root.menuVisible = false;
                    }
                }

                PowerMenuItem {
                    icon: "refresh"
                    label: "Reboot"
                    accentColor: Colors.green
                    Layout.column: 1
                    Layout.row: 0
                    onItemTriggered: {
                        cmdProcess.command = ["systemctl", "reboot"];
                        cmdProcess.running = true;
                        root.menuVisible = false;
                    }
                }

                PowerMenuItem {
                    icon: "bed"
                    label: "Suspend"
                    accentColor: Colors.mauve
                    Layout.column: 1
                    Layout.row: 1
                    onItemTriggered: {
                        cmdProcess.command = ["sh", "-c", "hyprland-save-windows && systemctl suspend"];
                        cmdProcess.running = true;
                        root.menuVisible = false;
                    }
                }
            }
        }
    }
}
