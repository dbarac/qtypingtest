import QtQuick
import QtQuick.Controls

Rectangle {
    id: testRect
    required property int testDuration
    width: parent.width; height: 330
    anchors.top: bar.bottom
    anchors.topMargin: 20
    color: "#202020"
    property bool testActive: false

    Text {
        id: remainingTime
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        color: testRect.testActive ?  "#c58940" : "#847869"//"#7ebab5"
        horizontalAlignment: Text.AlignHCenter
        text: parent.testDuration.toString()
        font.pixelSize: 60
        wrapMode: Text.WordWrap
    }

    Rectangle {
        id: hintRect
        anchors.top: remainingTime.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        width: 264
        height: 30
        radius: 5
        color: "#c58940"
        //visible: !testRect.testActive
        //opacity: testRect.testActive ? 0.0 : 1.0
        Text {
            id: hint
            text: "Start typing to start the test"
        anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: 20
            color: "#202020"
        }

        // fade-in and fade-out, depending on current testActive value
        property bool stateVisible: !testRect.testActive
        states: [
            State { when: hintRect.stateVisible;
                PropertyChanges { target: hintRect; opacity: 1.0 }
            },
            State { when: !hintRect.stateVisible;
                PropertyChanges { target: hintRect; opacity: 0.0 }
            }
        ]
        transitions: Transition {
            NumberAnimation { property: "opacity"; duration: 250}
        }
    }

    Timer {
        id: timer
        interval: 1000;
        repeat: true
        running: false
        onTriggered: function updateRemainingTime() {
            let remaining = parseInt(remainingTime.text)
            if (remaining > 1) {
                remaining--
            } else {
                remaining = parent.testDuration
                timer.stop()
                testRect.testActive = false
                root.wpmacc = "WPM: " + typingTest.calculateWPM(testDuration) +
                              " Accuracy: " + typingTest.calculateAccuracy() + "%"
            }
            remainingTime.text = remaining.toString()
        }
    }

    // test prompt - words which the user should type
    Text {
        id: testText
        anchors.topMargin: 10
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: hintRect.bottom
        width: 640//root.width - 200
        color: "#847869"//"white"
        horizontalAlignment: Text.AlignHCenter
        text: typingTest.guiTestStr;
        font.pixelSize: 23
        wrapMode: Text.WordWrap
    }

    Button {
        id: restartBtn
        anchors.top: testText.bottom
        anchors.topMargin: 30
        anchors.horizontalCenter: parent.horizontalCenter
        text: "restart"
        icon.source: "qrc:/images/arrow-rotate-right-solid.svg"
        icon.width: 24
        icon.color: hovered ? "#b5a593" : "#847869"
        icon.height: 24
        display: AbstractButton.TextBesideIcon

        onClicked: {
            remainingTime.text = parent.testDuration.toString()
            testRect.testActive = false
            timer.stop()
            input.text = ""
            root.wpmacc = ""
            typingTest.sampleWordDataset()
            typingTest.updateGuiTestStr(true)
        }
        palette {
            buttonText: hovered ? "#b5a593" : "#847869"
        }

        font.pixelSize: 25
        background: Rectangle {
               implicitWidth: 130
               implicitHeight: 40
               color: "transparent"//"#c58940"//"#847869"//button.down ? "#d6d6d6" : "#f6f6f6"
               //border.color: "#26282a"
               //border.width: 1
               //radius: 10
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
        focus: true
        cursorVisible: true
        onTextEdited: {
            if (!parent.testActive) {
                // start the test automatically
                // when the user starts typing
                parent.testActive = true;
                timer.start()
                root.wpmacc = ""
            }
            // track progress and update test words
            typingTest.processKbInput(input.text)

            // clear input field if the user finished typing the current word
            let pressedSpace = input.text.length > 0 && input.text.slice(-1) === " "
            if (pressedSpace) {
                input.text = ""
            }
        }
    }
}
