import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import qs.utils

PopupWindow {
    id: root
    
    required property var anchorWindow
    required property real anchorX
    required property real anchorY
    required property bool isVisible
    
    property alias menuWidth: menuBg.implicitWidth
    property alias menuHeight: menuBg.implicitHeight
    
    default property alias content: contentItem.data
    
    visible: isVisible
    
    anchor {
        window: anchorWindow
        rect {
            x: anchorX
            y: anchorY
            width: 0
            height: 0
        }
        gravity: Edges.Bottom | Edges.HCenter
        edges: Edges.Top | Edges.HCenter
        adjustment: PopupAdjustment.None
    }
    
    color: "transparent"
    
    implicitWidth: menuBg.implicitWidth
    implicitHeight: menuBg.implicitHeight
    
    // Click outside overlay
    MouseArea {
        x: -1000
        y: -1000
        width: 3000
        height: 3000
        z: -1
        onPressed: {
            root.isVisible = false;
        }
    }
    
    Rectangle {
        id: menuBg
        implicitWidth: width
        implicitHeight: height
        color: Qt.rgba(Colors.base.r, Colors.base.g, Colors.base.b, 1.0)
        radius: Config.radius
        border.color: Qt.rgba(Colors.surface1.r, Colors.surface1.g, Colors.surface1.b, 0.3)
        border.width: 1
        
        // Fade and scale animation
        opacity: 0.0
        scale: 0.95
        
        states: State {
            name: "visible"
            when: root.isVisible
            PropertyChanges { target: menuBg; opacity: 1.0; scale: 1.0 }
        }
        
        transitions: Transition {
            NumberAnimation { 
                properties: "opacity,scale"
                duration: 200
                easing.type: Easing.OutCubic
            }
        }
        
        Item {
            id: contentItem
            anchors.fill: parent
        }
    }
}
