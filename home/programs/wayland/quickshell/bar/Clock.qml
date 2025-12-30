import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import qs.components
import qs.utils
import qs.sidebar

WrapperMouseArea {
    id: root

    Layout.fillHeight: true

    property bool menuVisible: false

    // Calculate position
    property real screenCenterOffset: (barWindow.screen?.width ?? 1920) * 0.25
    property real barX: {
        const pos = mapToItem(barRight, 0, 0);
        const rightLayoutX = pos ? pos.x : 0;
        return screenCenterOffset + bar.width - (barRight.width - rightLayoutX);
    }

    onClicked: () => {
        NotificationState.notifOverlayOpen = false;
        menuVisible = !menuVisible;
    }

    RowLayout {
        anchors.centerIn: parent
        spacing: Config.padding * 2

        Text {
            text: Qt.formatDateTime(Utils.clock.date, "ddd MMM d  hh:mm")
            color: Colors.foreground
        }

        MaterialIcon {
            text: "notifications" + (NotificationState.allNotifs.length > 0 ? "_unread" : "")
            font.pointSize: Config.iconSize
        }
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
                text: "Calendar & Notifications"
                font.pixelSize: Config.iconSize + 2
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
