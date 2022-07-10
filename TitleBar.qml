import QtQuick

Item {
    height: 60

    Image {
        id: logo
        anchors.leftMargin: 10
        anchors.left: parent.left
        x: parent.x + 10
        y: parent.y + 10
        source: "qrc:/images/keyboard-solid.svg"
        sourceSize.width: 50
    }

    Text {
        id: title
        y: parent.y + 5
        color: "#fae1c3"
        anchors.left: logo.right
        anchors.leftMargin: 10
        anchors.topMargin: 10
        text: "qtypingtest"
        font.bold: false
        font.pixelSize: 35
    }
}

