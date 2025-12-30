import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Widgets
import qs.components
import qs.utils

WrapperMouseArea {
    id: root
    
    Layout.fillHeight: true
    implicitWidth: height * 0.6
    
    property bool nightLightEnabled: false
    
    Process {
        id: toggleCmd
        command: []
    }
    
    function toggleNightLight() {
        toggleCmd.command = nightLightEnabled 
            ? ["hyprctl", "hyprsunset", "identity"]
            : ["hyprctl", "hyprsunset", "temperature", "3000"];
        toggleCmd.running = true;
        nightLightEnabled = !nightLightEnabled;
    }
    
    onClicked: () => toggleNightLight()
    
    Item {
        anchors.centerIn: parent
        width: Config.iconSize
        height: Config.iconSize
        
        Text {
            anchors.centerIn: parent
            text: nightLightEnabled ? "󱠃" : "󱠂"
            font.family: "Symbols Nerd Font"
            font.pixelSize: Config.iconSize
            color: Colors.foreground
            
            Behavior on color {
                ColorAnimation { duration: 200 }
            }
        }
    }
    
    // Tooltip
    TextTooltip {
        id: tooltip
        targetItem: root
        targetRect: Qt.rect(root.width / 2, root.height + Config.padding * 2, 0, 0)
        targetText: nightLightEnabled ? "Night light on" : "Night light off"
    }
}
