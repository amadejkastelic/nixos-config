import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Widgets
import qs.components
import qs.utils
import qs.sidebar

WrapperMouseArea {
    id: root

    Layout.fillHeight: true
    implicitWidth: height

    property bool menuVisible: false
    
    // Calculate position
    property real screenCenterOffset: (barWindow.screen?.width ?? 1920) * 0.25
    property real barX: {
        const pos = mapToItem(barRight, 0, 0);
        const rightLayoutX = pos ? pos.x : 0;
        return screenCenterOffset + bar.width - (barRight.width - rightLayoutX);
    }

    Rectangle {
        id: notifButton
        anchors.centerIn: parent
        implicitWidth: parent.height * 0.4
        implicitHeight: parent.height * 0.4
        radius: height / 2
        color: root.containsMouse || menuVisible ? Colors.accent : "transparent"

        Behavior on color {
            ColorAnimation { duration: 200 }
        }

        Text {
            anchors.centerIn: parent
            text: "󰂚" // Bell icon
            font.family: "Symbols Nerd Font"
            font.pixelSize: parent.height * 0.7
            color: root.containsMouse || menuVisible ? Colors.crust : Colors.foreground

            Behavior on color {
                ColorAnimation { duration: 200 }
            }
        }
    }

    onClicked: {
        menuVisible = !menuVisible;
    }

    PopupMenu {
        id: notifMenu
        anchorWindow: barWindow
        anchorX: root.barX + (root.width / 2)
        anchorY: bar.height + Config.padding
        isVisible: root.menuVisible
        
        menuWidth: 400
        menuHeight: 500
        
        onIsVisibleChanged: {
            root.menuVisible = isVisible;
        }

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: Config.padding * 3
            spacing: Config.padding * 2

            Text {
                text: "Notifications & Calendar"
                font.pixelSize: Config.iconSize
                font.weight: Font.Bold
                color: Colors.foreground
            }

            Rectangle {
                Layout.fillWidth: true
                height: 1
                color: Colors.surface1
            }

            // Calendar widget
            Calendar {}

            Rectangle {
                Layout.fillWidth: true
                height: 1
                color: Colors.surface1
            }

            // Notification center
            NotificationCenter {}
        }
    }
}
