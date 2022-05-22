import QtQuick

Window {
    width: 800
    height: 600
    visible: true
    title: qsTr("qtypetest")
    color: "#4A4A4A"
    id: root

    Text {
        id: title

        color: "white"
        //horizontalAlignment: Text.AlignHCenter
        anchors.left: parent.left
        anchors.leftMargin: 10
        anchors.topMargin: 10
        text: "qtypetest"
        font.bold: false
        font.pixelSize: 30
    }

    Rectangle {
        id: inputbox

        y: title.y + title.height
        width: parent.width; height: 300
        anchors.topMargin: 20

        // color property
        color: "#4A4A40" //"#00ff00"

        Text {
            id: remainingTime
            anchors.horizontalCenter: parent.horizontalCenter

            // reference element by id
            //y: root.y

            // reference root element
            width: root.width - 200

            color: "#7ebab5"
            horizontalAlignment: Text.AlignHCenter
            //anchors.left: parent.left
            //anchors.leftMargin: 10
            //anchors.topMargin: 10
            text: "30"
            //font.bold: false
            font.pixelSize: 50
            wrapMode: Text.WordWrap
        }

        Text {
            id: testText
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: remainingTime.bottom

            // reference root element
            width: root.width - 200

            color: "white"
            horizontalAlignment: Text.AlignHCenter
            //anchors.left: parent.left
            //anchors.leftMargin: 10
            //anchors.topMargin: 10
            text: "later all come three still young their his than come or see my look day down mile far ask found man little ask say earth write important city"
            //font.bold: false
            font.pixelSize: 20
            wrapMode: Text.WordWrap
        }
    }
}
