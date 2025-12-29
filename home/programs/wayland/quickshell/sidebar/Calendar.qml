pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls
import QtQuick.Effects
import QtQuick.Layouts
import Quickshell.Widgets
import qs.utils
import qs.components

WrapperMouseArea {
    id: root
    Layout.fillWidth: true

    implicitHeight: wrapperItem.implicitHeight

    readonly property int gridW: Math.floor(width / 7) * 7
    property var locale: Qt.locale("en_GB")
    property int monthShift: 0

    readonly property date _today: new Date()
    readonly property int displayYear: _today.getFullYear() + Math.floor((_today.getMonth() + monthShift) / 12)
    readonly property int displayMonth: (_today.getMonth() + monthShift + 12) % 12

    acceptedButtons: Qt.NoButton
    onWheel: event => {
        root.monthShift += (event.angleDelta.y < 0) ? 1 : -1;
    }

    Item {
        id: wrapperItem

        implicitWidth: root.width
        implicitHeight: wrapper.implicitHeight

        RectangularShadow {
            anchors.fill: wrapper
            radius: wrapper.radius
            blur: Config.blurMax
            spread: Config.padding * 2
            color: Colors.windowShadow
        }

        WrapperRectangle {
            id: wrapper

            implicitWidth: parent.width
            color: "transparent"
            margin: Config.spacing
            radius: Config.radius

            ColumnLayout {
                id: calendarColumn
                spacing: 5

                // Calendar header
                RowLayout {
                    id: row
                    Layout.fillWidth: true
                    Layout.leftMargin: Config.spacing
                    Layout.rightMargin: Config.spacing
                    // uniformCellSizes: true

                    HoverTooltip {
                        Layout.fillWidth: true
                        acceptedButtons: Qt.LeftButton
                        onClicked: root.monthShift--
                        text: "Previous month"

                        Text {
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            text: "‹"
                            color: Colors.foreground
                            font.pixelSize: Config.iconSize + 4
                        }
                    }
                    HoverTooltip {
                        Layout.fillWidth: true
                        // Layout.alignment: Qt.AlignCenter
                        acceptedButtons: Qt.LeftButton
                        onClicked: root.monthShift = 0
                        text: (root.monthShift === 0) ? "" : "Jump to current month"
                        Text {
                            anchors.centerIn: parent
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            text: `${root.monthShift != 0 ? "• " : ""}${monthGrid.title}`
                            color: Colors.foreground
                            font.pixelSize: Config.iconSize
                            font.weight: Font.Medium
                        }
                    }
                    HoverTooltip {
                        // Layout.fillWidth: true
                        acceptedButtons: Qt.LeftButton
                        onClicked: root.monthShift++
                        text: "Next month"
                        Text {
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            text: "›"
                            color: Colors.foreground
                            font.pixelSize: Config.iconSize + 4
                        }
                    }
                }

                DayOfWeekRow {
                    locale: root.locale
                    Layout.fillWidth: true

                    delegate: Text {
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        text: shortName
                        font.weight: Font.Bold
                        font.pixelSize: Config.iconSize - 2
                        color: Colors.subtext0

                        required property string shortName
                    }
                }

                MonthGrid {
                    id: monthGrid
                    locale: root.locale
                    Layout.fillWidth: true

                    month: root.displayMonth
                    year: root.displayYear

                    width: parent.width
                    property int rows: 6
                    property int cellH: 24
                    implicitHeight: rows * cellH

                    delegate: WrapperRectangle {
                        id: wr
                        required property var model
                        radius: Config.radius / 2
                        readonly property bool today: model.day === root._today.getDate() && model.month === root._today.getMonth() && model.year === root._today.getFullYear()
                        color: today ? Colors.accent : "transparent"

                        Text {
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            text: wr.model.day
                            font.pixelSize: Config.iconSize - 2
                            color: {
                                if (wr.model.month !== root.displayMonth) {
                                    return Colors.overlay0;
                                }
                                if (wr.today) {
                                    return Colors.crust;
                                }
                                return Colors.foreground;
                            }
                        }
                    }
                }
            }
        }
    }
}
