pragma ComponentBehavior: Bound
import Quickshell
import Quickshell.Wayland
import Quickshell.Widgets
import QtQuick
import QtQuick.Effects
import QtQuick.Layouts
import qs.utils

Scope {
    id: scope
    property bool osdVisible: false
    property real progress: 0
    property string icon: ""

    property var sinkVolume: PipeWireState.defaultSink?.audio?.volume
    onSinkVolumeChanged: {
        if (sinkVolume !== undefined) {
            scope.osdVisible = true;
            scope.icon = PipeWireState.sinkIcon();
            scope.progress = sinkVolume;
            hideTimer.restart();
        }
    }

    property var sinkMuted: PipeWireState.defaultSink?.audio?.muted
    onSinkMutedChanged: {
        if (sinkMuted !== undefined) {
            scope.osdVisible = true;
            scope.icon = PipeWireState.sinkIcon();
            scope.progress = PipeWireState.defaultSink?.audio?.volume ?? 0;
            hideTimer.restart();
        }
    }

    Connections {
        target: BrightnessState

        function onBrightnessChanged() {
            scope.osdVisible = true;
            scope.icon = "display-brightness-symbolic";
            scope.progress = BrightnessState.brightness ?? 0;
            hideTimer.restart();
        }
    }

    Timer {
        id: hideTimer
        interval: Config.osdTimeout
        onTriggered: scope.osdVisible = false
    }

    LazyLoader {
        active: scope.osdVisible

        PanelWindow {
            id: root

            screen: Config.preferredMonitor

            WlrLayershell.exclusionMode: ExclusionMode.Ignore
            WlrLayershell.namespace: "quickshell:osd"
            color: 'transparent'
            mask: Region {}

            anchors {
                bottom: true
            }

            margins {
                bottom: Config.barHeight + Config.padding * 4
            }

            implicitWidth: 320
            implicitHeight: 56

            Rectangle {
                anchors.fill: parent
                radius: height / 2
                color: Colors.bgBar

                RowLayout {
                    anchors {
                        fill: parent
                        leftMargin: 16
                        rightMargin: 16
                    }
                    spacing: 16

                    IconImage {
                        implicitSize: 32
                        source: Quickshell.iconPath(scope.icon)
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        implicitHeight: 6
                        radius: 3
                        color: Colors.surface0

                        Rectangle {
                            anchors {
                                left: parent.left
                                top: parent.top
                                bottom: parent.bottom
                            }

                            implicitWidth: parent.width * scope.progress
                            radius: parent.radius
                            color: Colors.accent
                        }
                    }
                }
            }
        }
    }
}
