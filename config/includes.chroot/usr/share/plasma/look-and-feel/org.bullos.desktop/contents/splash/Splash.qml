import QtQuick

// Pantalla de carga de la sesión de BullOS
Rectangle {
    id: root
    color: "#120C09"
    property int stage

    Image {
        id: logo
        anchors.centerIn: parent
        anchors.verticalCenterOffset: -40
        source: "images/logo.png"
        sourceSize.width: 180
        sourceSize.height: 180
    }
    Text {
        anchors.top: logo.bottom
        anchors.topMargin: 20
        anchors.horizontalCenter: parent.horizontalCenter
        text: "BullOS"
        color: "#F3E6D3"
        font.pixelSize: 40
        font.bold: true
        font.family: "Inter"
    }
    Rectangle {
        anchors.horizontalCenter: parent.horizontalCenter
        y: parent.height * 0.78
        width: 220; height: 4; radius: 2
        color: "#2A1D14"
        Rectangle {
            height: parent.height; radius: 2
            color: "#E0762B"
            width: parent.width * Math.min(root.stage, 6) / 6
            Behavior on width { NumberAnimation { duration: 400 } }
        }
    }
}
