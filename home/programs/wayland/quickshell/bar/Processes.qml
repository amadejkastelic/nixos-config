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

    property var processes: []
    property bool menuVisible: false

    Rectangle {
        id: processButton
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
            text: "󰍹" // Process/list icon
            font.family: "Symbols Nerd Font"
            font.pixelSize: parent.height * 0.7
            color: root.containsMouse || menuVisible ? Colors.crust : Colors.foreground

            Behavior on color {
                ColorAnimation { duration: 200 }
            }
        }
    }

    Process {
        id: psProcess
        running: true
        command: ["sh", "-c", "ps aux --sort=-%cpu | head -n 11 | tail -n 10"]
        
        stdout: SplitParser {
            onRead: data => {
                const lines = data.trim().split('\n');
                const procs = lines.map(line => {
                    const parts = line.trim().split(/\s+/);
                    if (parts.length >= 11) {
                        return {
                            user: parts[0],
                            cpu: parts[2],
                            mem: parts[3],
                            command: parts.slice(10).join(' ')
                        };
                    }
                    return null;
                }).filter(p => p !== null);
                
                root.processes = procs;
            }
        }
    }

    Timer {
        interval: 5000
        running: true
        repeat: true
        onTriggered: psProcess.running = true
    }

    onClicked: {
        menuVisible = !menuVisible;
    }

    PopupWindow {
        id: processMenu
        visible: menuVisible && QsWindow.window !== null
        anchor.window: QsWindow.window
        anchor.rect.x: root.x
        anchor.rect.y: QsWindow.window?.height ?? 0
        anchor.gravity: Edges.Top | Edges.Right
        anchor.edges: Edges.Bottom | Edges.Right
        
        color: "transparent"
        mask: Region { item: menuBg }

        implicitWidth: 400
        implicitHeight: Math.min(root.processes.length * 30 + Config.padding * 4, 350)

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
                    text: "Top Processes (CPU)"
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
                    
                    model: root.processes
                    spacing: Config.padding

                    delegate: Rectangle {
                        required property var modelData
                        width: ListView.view.width
                        height: 24
                        color: "transparent"

                        RowLayout {
                            anchors.fill: parent
                            spacing: Config.spacing

                            Text {
                                Layout.preferredWidth: 60
                                text: modelData.cpu + "%"
                                font.pixelSize: Config.iconSize - 3
                                font.weight: Font.Medium
                                color: Colors.accent
                            }

                            Text {
                                Layout.preferredWidth: 60
                                text: modelData.mem + "%"
                                font.pixelSize: Config.iconSize - 3
                                color: Colors.subtext0
                            }

                            Text {
                                Layout.fillWidth: true
                                text: modelData.command
                                font.pixelSize: Config.iconSize - 3
                                color: Colors.foreground
                                elide: Text.ElideRight
                            }
                        }
                    }
                }
            }
        }
    }
}
