import QtQuick

Window {
    width: 800
    height: 600
    visible: true
    title: "qtypetest"
    color: "#4A4A4A"
    id: root

    Text {
        id: title
        color: "white"
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
        color: "#4A4A40"

        Text {
            id: remainingTime
            anchors.horizontalCenter: parent.horizontalCenter
            width: root.width - 200
            color: "#7ebab5"
            horizontalAlignment: Text.AlignHCenter
            text: "30"
            font.pixelSize: 50
            wrapMode: Text.WordWrap
        }

        Timer {
            id: timer
            interval: 1000; running: true; repeat: true
            onTriggered: function updateRemainingTime() {
                let remaining = parseInt(remainingTime.text)
                console.log(remainingTime.text)
                if (remaining > 0) {
                    remaining--
                } else {
                    remaining = 30
                }
                remainingTime.text = remaining.toString()
            }
        }

        Text {
            id: testText
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: remainingTime.bottom
            width: root.width - 200
            color: "white"
            horizontalAlignment: Text.AlignHCenter
            text: "later all come three still young their his than come or see my look day down mile far ask found man little ask say earth write important city"
            font.pixelSize: 20
            wrapMode: Text.WordWrap
            focus: true
            Keys.onPressed: function logPressedKey(event) {
                console.log("pressed " + String.fromCharCode(event.key).toLowerCase())
            }
            //Keys.onEscapePressed: {
            //    label.text = ''
            //}
        }
    }
}
