import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import qs.utils
import qs.components

WrapperMouseArea {
    id: root

    Layout.fillHeight: true
    implicitWidth: mediaContent.implicitWidth
    visible: MprisState.player

    property bool menuVisible: false

    acceptedButtons: Qt.RightButton | Qt.LeftButton

    onClicked: event => {
        event.accepted = true;
        if (event.button === Qt.LeftButton) {
            menuVisible = !menuVisible;
        }
    }
    
    // Calculate position in the bar (accounting for centered bar)
    property real screenCenterOffset: (barWindow.screen?.width ?? 1920) * 0.25
    property real barX: {
        const pos = mapToItem(barMiddle, 0, 0);
        const middleLayoutX = pos ? pos.x : 0;
        // barMiddle is centered, calculate from screen center
        return screenCenterOffset + (bar.width / 2) - (barMiddle.width / 2) + middleLayoutX;
    }

    RowLayout {
        id: mediaContent
        anchors.centerIn: parent
        height: parent.height * 0.9
        spacing: Config.spacing

        // Album art - rounded
        Item {
            Layout.preferredHeight: root.height * 0.75
            Layout.preferredWidth: height

            Rectangle {
                anchors.fill: parent
                radius: Config.padding * 2
                color: Colors.surface1
            }

            RoundedImage {
                id: artwork
                anchors.fill: parent
                source: MprisState.player?.trackArtUrl || ""
                radius: Config.padding * 2
                fillMode: Image.PreserveAspectCrop
                visible: (MprisState.player?.trackArtUrl ?? "") !== ""
            }

            Text {
                anchors.centerIn: parent
                text: "󰝚"
                font.family: "Symbols Nerd Font"
                font.pixelSize: parent.height * 0.5
                color: Colors.overlay0
                visible: (MprisState.player?.trackArtUrl ?? "") === ""
            }
        }

        // Track info - single line
        Text {
            Layout.maximumWidth: 200
            text: {
                const title = MprisState.player?.trackTitle || "No title";
                const artist = MprisState.player?.trackArtist || "";
                return artist ? `${title} - ${artist}` : title;
            }
            font.pixelSize: Config.iconSize - 3
            color: Colors.foreground
            elide: Text.ElideRight
        }


    }

    PopupMenu {
        id: mediaMenu
        anchorWindow: barWindow
        anchorX: root.barX + (mediaContent.width / 2)
        anchorY: bar.height + Config.padding
        isVisible: root.menuVisible
        
        menuWidth: 350
        menuHeight: 400
        
        onIsVisibleChanged: {
            root.menuVisible = isVisible;
        }

        ColumnLayout {
                anchors.fill: parent
                anchors.margins: Config.padding * 4
                spacing: Config.padding * 2

                // Large album art
                Item {
                    Layout.alignment: Qt.AlignHCenter
                    Layout.preferredWidth: 200
                    Layout.preferredHeight: 200

                    Rectangle {
                        anchors.fill: parent
                        radius: Config.radius * 2
                        color: Colors.surface1
                    }

                    RoundedImage {
                        anchors.fill: parent
                        source: MprisState.player?.trackArtUrl || ""
                        radius: Config.radius * 2
                        fillMode: Image.PreserveAspectCrop
                        visible: (MprisState.player?.trackArtUrl ?? "") !== ""
                    }

                    Text {
                        anchors.centerIn: parent
                        text: "󰝚"
                        font.family: "Symbols Nerd Font"
                        font.pixelSize: 80
                        color: Colors.overlay0
                        visible: (MprisState.player?.trackArtUrl ?? "") === ""
                    }
                }

                // Track title
                Text {
                    Layout.fillWidth: true
                    text: MprisState.player?.trackTitle || "No title"
                    font.pixelSize: Config.iconSize + 4
                    font.weight: Font.Bold
                    color: Colors.foreground
                    horizontalAlignment: Text.AlignHCenter
                    wrapMode: Text.WordWrap
                }

                // Artist
                Text {
                    Layout.fillWidth: true
                    text: MprisState.player?.trackArtist || "Unknown artist"
                    font.pixelSize: Config.iconSize
                    color: Colors.subtext0
                    horizontalAlignment: Text.AlignHCenter
                }

                // Album
                Text {
                    Layout.fillWidth: true
                    text: MprisState.player?.trackAlbum || ""
                    font.pixelSize: Config.iconSize - 2
                    color: Colors.subtext1
                    horizontalAlignment: Text.AlignHCenter
                    visible: text !== ""
                }

                Item { Layout.fillHeight: true }

                // Playback controls
                RowLayout {
                    Layout.alignment: Qt.AlignHCenter
                    spacing: Config.spacing * 4

                    // Previous
                    Rectangle {
                        width: 40
                        height: 40
                        radius: 20
                        color: prevMouse.containsMouse ? Colors.surface1 : "transparent"

                        Text {
                            anchors.centerIn: parent
                            text: "󰒮"
                            font.family: "Symbols Nerd Font"
                            font.pixelSize: 24
                            color: Colors.foreground
                        }

                        MouseArea {
                            id: prevMouse
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: MprisState.player?.previous()
                        }
                    }

                    // Play/Pause
                    Rectangle {
                        width: 50
                        height: 50
                        radius: 25
                        color: playMouse.containsMouse ? Colors.accent : Colors.surface1

                        Behavior on color {
                            ColorAnimation { duration: 200 }
                        }

                        Text {
                            anchors.centerIn: parent
                            text: {
                                const state = MprisState.player?.playbackState;
                                // State: 0 = Stopped, 1 = Playing, 2 = Paused
                                return state === 1 ? "󰏤" : "󰐊";
                            }
                            font.family: "Symbols Nerd Font"
                            font.pixelSize: 28
                            color: playMouse.containsMouse ? Colors.crust : Colors.foreground

                            Behavior on color {
                                ColorAnimation { duration: 200 }
                            }
                        }

                        MouseArea {
                            id: playMouse
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                console.log("Before toggle:", MprisState.player?.playbackState);
                                MprisState.player?.togglePlaying();
                                console.log("After toggle:", MprisState.player?.playbackState);
                            }
                        }
                    }

                    // Next
                    Rectangle {
                        width: 40
                        height: 40
                        radius: 20
                        color: nextMouse.containsMouse ? Colors.surface1 : "transparent"

                        Text {
                            anchors.centerIn: parent
                            text: "󰒭"
                            font.family: "Symbols Nerd Font"
                            font.pixelSize: 24
                            color: Colors.foreground
                        }

                        MouseArea {
                            id: nextMouse
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: MprisState.player?.next()
                        }
                    }
                }
            }
    }
}
