import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Widgets
import qs.utils
import qs.components

WrapperMouseArea {
    id: root

    Layout.fillHeight: true
    implicitWidth: height

    property var runningApps: []
    property bool menuVisible: false

    Rectangle {
        id: taskButton
        anchors.centerIn: parent
        implicitWidth: parent.height * 0.4
        implicitHeight: parent.height * 0.4
        radius: height / 2
        color: root.containsMouse || menuVisible ? Colors.accent : Colors.surface1

        Behavior on color {
            ColorAnimation { duration: 200 }
        }

        Text {
            anchors.centerIn: parent
            text: "󰘔" // Grid/apps icon
            font.family: "Symbols Nerd Font"
            font.pixelSize: parent.height * 0.7
            color: root.containsMouse || menuVisible ? Colors.crust : Colors.foreground

            Behavior on color {
                ColorAnimation { duration: 200 }
            }
        }

        // Badge showing number of running apps
        Rectangle {
            visible: runningApps.length > 0
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.rightMargin: -2
            anchors.topMargin: -2
            width: 12
            height: 12
            radius: 6
            color: Colors.accent

            Text {
                anchors.centerIn: parent
                text: runningApps.length
                font.pixelSize: 8
                font.weight: Font.Bold
                color: Colors.crust
            }
        }
    }

    Process {
        id: getApps
        running: true
        // Get running GUI apps using ps and matching against common GUI apps
        command: ["sh", "-c", "ps aux | grep -E '(steam|cider|easyeffects|discord|firefox|chromium|spotify|code|thunar|nautilus)' | grep -v grep | awk '{for(i=11;i<=NF;i++) printf $i\" \"; print \"\"}' | sort -u"]
        
        stdout: SplitParser {
            onRead: data => {
                const lines = data.trim().split('\n').filter(line => line.length > 0);
                const apps = lines.map(line => {
                    // Extract app name from command line
                    const parts = line.trim().split(/[\s\/]+/);
                    for (let part of parts) {
                        if (part.match(/^(steam|cider|easyeffects|discord|firefox|chromium|spotify|code|thunar|nautilus|brave)/i)) {
                            return part;
                        }
                    }
                    return parts[0];
                }).filter((app, index, self) => {
                    // Remove duplicates
                    return app && self.indexOf(app) === index;
                });
                
                root.runningApps = apps;
            }
        }
    }

    Timer {
        interval: 3000
        running: true
        repeat: true
        onTriggered: getApps.running = true
    }

    onClicked: {
        menuVisible = !menuVisible;
    }

    PopupWindow {
        id: taskMenu
        visible: menuVisible && QsWindow.window !== null
        anchor.window: QsWindow.window
        anchor.rect.x: root.x
        anchor.rect.y: QsWindow.window?.height ?? 0
        anchor.gravity: Edges.Top | Edges.Right
        anchor.edges: Edges.Bottom | Edges.Right
        
        color: "transparent"
        mask: Region { item: menuBg }

        implicitWidth: 300
        implicitHeight: Math.min(root.runningApps.length * 40 + Config.padding * 4 + 50, 400)

        Rectangle {
            id: menuBg
            anchors.fill: parent
            color: Colors.base
            radius: Config.radius
            border.color: Colors.surface1
            border.width: 1

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: Config.padding * 2
                spacing: Config.padding

                Text {
                    text: "Running Applications"
                    font.pixelSize: Config.iconSize
                    font.weight: Font.Bold
                    color: Colors.foreground
                }

                Rectangle {
                    Layout.fillWidth: true
                    height: 1
                    color: Colors.surface1
                }

                ListView {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    clip: true
                    
                    model: root.runningApps
                    spacing: Config.padding

                    delegate: Rectangle {
                        required property string modelData
                        width: ListView.view.width
                        height: 32
                        radius: Config.radius / 2
                        color: mouseArea.containsMouse ? Colors.surface1 : "transparent"

                        Behavior on color {
                            ColorAnimation { duration: 150 }
                        }

                        RowLayout {
                            anchors.fill: parent
                            anchors.margins: Config.padding
                            spacing: Config.spacing

                            Text {
                                text: "󰣆" // App icon placeholder
                                font.family: "Symbols Nerd Font"
                                font.pixelSize: Config.iconSize
                                color: Colors.accent
                            }

                            Text {
                                Layout.fillWidth: true
                                text: modelData.charAt(0).toUpperCase() + modelData.slice(1)
                                font.pixelSize: Config.iconSize - 2
                                color: Colors.foreground
                                elide: Text.ElideRight
                            }
                        }

                        MouseArea {
                            id: mouseArea
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            
                            onClicked: {
                                // Could add actions here like focusing the window
                                menuVisible = false;
                            }
                        }
                    }
                }

                Text {
                    visible: root.runningApps.length === 0
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    text: "No applications running"
                    font.pixelSize: Config.iconSize - 2
                    color: Colors.subtext0
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }
        }
    }
}
