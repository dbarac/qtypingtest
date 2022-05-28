import QtQuick
import QtQuick.Controls

Window {
    width: 1000
    height: 800
    visible: true
    title: "qtypetest"
    color: "#202020"
    id: root

    Image {
        id: kb
        //anchors.topMargin: 20
        anchors.leftMargin: 10
        anchors.left: parent.left
        x: 10
        y: 10
        source: "qrc:/images/keyboard-solid.svg"
        sourceSize.width: 50
        //sourceSize.height: parent.height
    }

    Text {
        id: title
        y: 5
        color: "#fae1c3"
        anchors.left: kb.right
        anchors.leftMargin: 10
        anchors.topMargin: 10
        text: "qtypetest"
        font.bold: false
        font.pixelSize: 35
    }

    Rectangle {
        id: inputbox
        y: title.y + kb.height + 20
        width: parent.width; height: 300
        anchors.topMargin: 20
        color: "#202020"
        //color: "#4A4A40" boja za debug
        property bool testActive: false

        Text {
            id: remainingTime
            anchors.horizontalCenter: parent.horizontalCenter
            width: root.width - 200
            color: inputbox.testActive ?  "#c58940" : "#847869"//"#7ebab5"
            horizontalAlignment: Text.AlignHCenter
            text: "30"
            font.pixelSize: 60
            wrapMode: Text.WordWrap
        }

        Timer {
            id: timer
            interval: 1000;
            repeat: true
            running: false
            onTriggered: function updateRemainingTime() {
                let remaining = parseInt(remainingTime.text)
                //console.log(remainingTime.text)
                if (remaining > 1) {
                    remaining--
                } else {
                    remaining = 30
                    timer.stop()
                    inputbox.testActive = false
                }
                remainingTime.text = remaining.toString()
            }
        }

        Text {
            id: testText
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: remainingTime.bottom
            width: 640//root.width - 200
            color: "#847869"//"white"
            horizontalAlignment: Text.AlignHCenter
            //text: "later all come three still young their his than come or see my look day down mile far ask found man little ask say earth write important city"
            text: typingTest.guiTestStr;
            font.pixelSize: 23
            wrapMode: Text.WordWrap
            //focus: true
            Keys.onPressed: function logPressedKey(event) {
                console.log("pressed " + String.fromCharCode(event.key).toLowerCase())
            }
            //Keys.onEscapePressed: {
            //    label.text = ''
            //}
        }

        Button {
            id: restartBtn
            anchors.top: testText.bottom
            anchors.topMargin: 30
            anchors.horizontalCenter: parent.horizontalCenter
            text: "Restart"
            //onClicked: typingTest.doSomething("TEXT FROM QML")
            onClicked: {
                remainingTime.text = "30"
                inputbox.testActive = false
                timer.stop()
                input.text = ""
                typingTest.sampleWordDataset()
                typingTest.updateGuiTestStr(true)
            }
            font.pixelSize: 25
            background: Rectangle {
                   implicitWidth: 120
                   implicitHeight: 40
                   color: "#c58940"//"#847869"//button.down ? "#d6d6d6" : "#f6f6f6"
                   border.color: "#26282a"
                   border.width: 1
                   radius: 10
            }
            focusPolicy: Qt.NoFocus
        }

        TextInput {
            id: input
            anchors.top: restartBtn.bottom
            anchors.topMargin: 30
            anchors.horizontalCenter: parent.horizontalCenter
            font.pixelSize: 30
            color: "#fae1c3"
            //text: "Text"
            focus: true
            cursorVisible: true
            onTextEdited: {
                if (!parent.testActive) {
                    parent.testActive = true;
                    timer.start()
                }
                /*
                let shouldClearInput = typingTest.processKbInput(input.text)
                if (shouldClearInput) {
                    input.text = ""
                }*/
                typingTest.processKbInput(input.text)
                let pressedSpace = input.text.length > 0 && input.text.slice(-1) === " "
                if (pressedSpace) {
                    input.text = ""
                }
            }
        }
    }

    Rectangle {
        id: resultsRect
        anchors.top: inputbox.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        color: "#847869"
        width: 640
        height: 200
        //y: inputbox.height

        Text {
            id: wpmacc
            text: "wpm: 107 accuracy: 80%"
            font.pixelSize: 30
            color: "#91170c"
            anchors.top: inputbox.bottom
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }
}
