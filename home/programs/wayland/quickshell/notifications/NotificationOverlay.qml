pragma ComponentBehavior: Bound

import qs.utils
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Notifications
import Quickshell.Wayland

PanelWindow {
    id: root

    screen: Config.preferredMonitor
    visible: NotificationState.notifOverlayOpen && !Config.showSidebar && !Config.doNotDisturb
    
    WlrLayershell.exclusionMode: ExclusionMode.Ignore
    WlrLayershell.namespace: "quickshell:notifications:overlay"
    
    implicitWidth: Config.notificationWidth + Config.padding * 6
    
    color: "transparent"
    mask: Region {
        item: notifs
    }

    // Position below bar's right edge (bar is centered at 50% screen width)
    anchors {
        top: true
        right: true
    }

    margins {
        // Align notification right edge with bar right edge
        // Bar is centered at 50% screen width, 50% width
        // Bar right edge is at screen.width * 0.75
        // Right margin = distance from screen right edge to bar right edge = 25% of screen
        right: screen.width * 0.25
        top: Config.barHeight + Config.padding * 2
    }

    ColumnLayout {
        id: notifs

        width: parent.width
        anchors {
            top: parent.top
            right: parent.right
            topMargin: Config.padding * 2
        }

        Repeater {
            model: NotificationState.popupNotifs

            NotificationBox {
                id: notifBox
                required property Notification modelData
                n: modelData

                Timer {
                    running: root.visible
                    interval: (notifBox.n.expireTimeout > 0 ? notifBox.n.expireTimeout : Config.notificationExpireTimeout) * 1000
                    onTriggered: {
                        NotificationState.notifDismissByNotif(notifBox.n);
                    }
                }
            }
        }
    }
}
