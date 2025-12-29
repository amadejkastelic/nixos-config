import QtQuick

Item {
    id: root
    
    property alias source: img.source
    property real radius: 0
    property int fillMode: Image.PreserveAspectCrop
    
    Image {
        id: img
        anchors.fill: parent
        visible: false
        fillMode: root.fillMode
        asynchronous: true
        smooth: true
    }
    
    ShaderEffect {
        anchors.fill: parent
        property var source: img
        property real itemWidth: width
        property real itemHeight: height
        property real sourceWidth: img.sourceSize.width
        property real sourceHeight: img.sourceSize.height
        property real cornerRadius: root.radius
        property real imageOpacity: 1.0
        property int fillMode: root.fillMode
        
        fragmentShader: "rounded_image.frag.qsb"
    }
}
