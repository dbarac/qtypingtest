import QtQuick
import QtQuick.Controls

Window {
    width: 1000
    height: 800
    visible: true
    title: "qtypetest"
    color: "#202020"
    id: root

    Text {
        id: title
        color: "#fae1c3"
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
        color: "#202020"
        //color: "#4A4A40" boja za debug
        property bool testActive: false

        Text {
            id: remainingTime
            anchors.horizontalCenter: parent.horizontalCenter
            width: root.width - 200
            color: "#c58940"//"#7ebab5"
            horizontalAlignment: Text.AlignHCenter
            text: "30"
            font.pixelSize: 50
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
                if (remaining > 0) {
                    remaining--
                } else {
                    remaining = 30
                    timer.stop()
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
            text: "typingTest.doSomething()"
            //onClicked: typingTest.doSomething("TEXT FROM QML")
            onClicked: {
                remainingTime.text = "30"
                timer.stop()
                input.text = ""
                typingTest.sampleWordDataset()
            }
            focusPolicy: Qt.NoFocus
        }

        TextInput {
            id: input
            anchors.top: restartBtn.bottom
            anchors.topMargin: 30
            anchors.horizontalCenter: parent.horizontalCenter
            font.pixelSize: 30
            color: "white"
            //text: "Text"
            focus: true
            cursorVisible: true
            onTextEdited: {
                if (!parent.testActive) {
                    parent.testActive = true;
                    timer.start()
                }

                let shouldClearInput = typingTest.processKbInput(input.text)
                if (shouldClearInput) {
                    input.text = ""
                }
            }
        }
        /*
        Button {
                text: "Cancel"
                onClicked: model.revert()
            }
        Button {
            text: "A button"
            style: ButtonStyle {
                background: Rectangle {
                    implicitWidth: 100
                    implicitHeight: 25
                    border.width: control.activeFocus ? 2 : 1
                    border.color: "#888"
                    radius: 4
                    gradient: Gradient {
                        GradientStop { position: 0 ; color: control.pressed ? "#ccc" : "#eee" }
                        GradientStop { position: 1 ; color: control.pressed ? "#aaa" : "#ccc" }
                    }
                }
            }
        }
        Button {
            id: control
            text: qsTr("Restart")
            anchors.top: testText.bottom
            anchors.topMargin: 20
            anchors.horizontalCenter: parent.horizontalCenter

            contentItem: Text {
                text: control.text
                //font: control.font
                font.pixelSize: 30
                opacity: enabled ? 1.0 : 0.3
                color: control.down ? "#17a81a" : "#21be2b"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                elide: Text.ElideRight
            }

            background: Rectangle {
                implicitWidth: 140
                implicitHeight: 60
                opacity: enabled ? 1 : 0.3
                //border.color: control.down ? "#7ebab5" "#17a81a" : "#21be2b"
                border.color: "#7ebab5"
                color: "#4A4A4A"
                border.width: 1
                radius: 2
            }
        }

        Text {
            //anchors.fill: parent;
            anchors.top: control.bottom
            text: '<font color="red">I am the </font><b>very</b> eee of' +
                         '<p>a <span style="text-decoration: overline">modern</span> ' +
                         '<i>major</i>!</p>'
            font.pointSize: 14
            textFormat: Text.RichText
        }
    */
    }
}
