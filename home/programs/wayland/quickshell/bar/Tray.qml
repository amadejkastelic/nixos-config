import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.SystemTray
import Quickshell.Widgets
import qs.components
import qs.utils

WrapperMouseArea {
    id: root

    Layout.fillHeight: true
    implicitWidth: height

    property bool menuVisible: false
    property int itemCount: SystemTray.items.values.length
    
    // Calculate position: tray is in barRight layout on the right side
    // The bar is centered and 50% width, so we need to account for the offset
    property real screenCenterOffset: (barWindow.screen?.width ?? 1920) * 0.25  // 25% from left edge to bar start
    property real barX: {
        // Get position within barRight layout, then add to the bar's screen position
        const pos = mapToItem(barRight, 0, 0);
        const rightLayoutX = pos ? pos.x : 0;
        // barRight is anchored to the right of bar, so we need bar.width - distance from right
        return screenCenterOffset + bar.width - (barRight.width - rightLayoutX);
    }

    Rectangle {
        id: trayButton
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
            text: menuVisible ? "󰅃" : "󰅀" // Chevron down/up
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
        id: trayMenu
        anchorWindow: barWindow
        anchorX: root.barX + (root.width / 2)
        anchorY: bar.height + Config.padding
        isVisible: root.menuVisible
        
        menuWidth: 280
        menuHeight: Math.min(Math.ceil(root.itemCount / 3) * 90 + Config.padding * 8 + 40, 400)
        
        onIsVisibleChanged: {
            root.menuVisible = isVisible;
        }

        ColumnLayout {
                anchors.fill: parent
                anchors.margins: Config.padding * 3
                spacing: Config.padding * 2

                Text {
                    text: "System Tray"
                    font.pixelSize: Config.iconSize
                    font.weight: Font.Bold
                    color: Colors.foreground
                }

                Flow {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    spacing: Config.padding * 2

                    Repeater {
                        model: SystemTray.items.values

                        Rectangle {
                            required property SystemTrayItem modelData
                            width: 80
                            height: 80
                            radius: Config.radius
                            color: trayMouseArea.containsMouse ? Colors.surface1 : "transparent"

                            Behavior on color {
                                ColorAnimation { duration: 150 }
                            }

                            ColumnLayout {
                                anchors.fill: parent
                                anchors.margins: Config.padding * 2
                                spacing: Config.padding

                                IconImage {
                                    Layout.alignment: Qt.AlignHCenter
                                    Layout.preferredWidth: Config.iconSize * 2.5
                                    Layout.preferredHeight: Config.iconSize * 2.5
                                    source: modelData.icon
                                    mipmap: true
                                }

                                Text {
                                    Layout.fillWidth: true
                                    Layout.fillHeight: true
                                    text: modelData.tooltipTitle || modelData.title || "Unknown"
                                    font.pixelSize: 9
                                    color: Colors.foreground
                                    elide: Text.ElideMiddle
                                    horizontalAlignment: Text.AlignHCenter
                                    wrapMode: Text.WordWrap
                                    maximumLineCount: 2
                                }
                            }

                            MouseArea {
                                id: trayMouseArea
                                anchors.fill: parent
                                hoverEnabled: true
                                acceptedButtons: Qt.LeftButton | Qt.RightButton
                                cursorShape: Qt.PointingHandCursor
                                
                                onClicked: event => {
                                    switch (event.button) {
                                    case Qt.LeftButton:
                                        modelData.activate();
                                        root.menuVisible = false;
                                        break;
                                    case Qt.RightButton:
                                        if (modelData.hasMenu) {
                                            contextMenu.open();
                                        }
                                        break;
                                    }
                                    event.accepted = true;
                                }

                                QsMenuAnchor {
                                    id: contextMenu
                                    menu: modelData.menu
                                    onVisibleChanged: QsWindow.window.inhibitGrab = visible

                                    anchor {
                                        item: trayMouseArea
                                        edges: Edges.Right | Edges.Top
                                        gravity: Edges.Left | Edges.Bottom
                                        adjustment: PopupAdjustment.All
                                    }
                                }
                            }
                        }
                    }
                }

                Text {
                    visible: root.itemCount === 0
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    text: "No tray items"
                    font.pixelSize: Config.iconSize - 2
                    color: Colors.subtext0
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }
    }
}
