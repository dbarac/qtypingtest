import QtQuick
import QtQuick.Controls

Rectangle {
    id: testRect
    required property int testDuration
    width: parent.width; height: 330
    anchors.top: bar.bottom
    anchors.topMargin: 20
    color: "#202020"
    state: "testReady"
    property int remainingTime: testDuration

    states: [
        State { name: "testReady"
            PropertyChanges { target: hintRect; opacity: 1.0 }
        },
        State { name: "testActive"
            PropertyChanges { target: hintRect; opacity: 0.0 }
        },
        State { name: "testFinished"
            PropertyChanges { target: hintRect; opacity: 0.0 }
            PropertyChanges { target: restartBtn; focus: true }
        }
    ]
    transitions: Transition {
        NumberAnimation { target: hintRect; property: "opacity"; duration: 250}
    }

    Text {
        id: remainingTimeStr
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        color: testRect.state === "testActive" ?  "#c58940" : "#847869"
        horizontalAlignment: Text.AlignHCenter
        text: parent.remainingTime.toString()
        font.pixelSize: 60
        wrapMode: Text.WordWrap
    }

    Rectangle {
        id: hintRect
        anchors.top: remainingTimeStr.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        width: 264
        height: 30
        radius: 5
        color: "#c58940"
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
    }

    function updateRemainingTime() {
        remainingTime--
    }

    function finishTest() {
        testRect.state = "testFinished"
        input.clear()
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
        text: typingTest.testPrompt;
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
        icon.color: (hovered || activeFocus) ? "#b5a593" : "#847869"
        icon.height: 24
        display: AbstractButton.TextBesideIcon
        Keys.onReturnPressed: (event) => {
            event.accepted = true
            clicked()
        }
        Keys.onSpacePressed: (event) => {
            // empty handler, prevents onClicked
            // from being called when space is pressed
        }
        onClicked: {
            remainingTime = parent.testDuration
            testRect.state = "testReady"
            input.text = ""
            input.focus = true
            typingTest.reset()
        }
        palette {
            buttonText: (hovered || activeFocus) ? "#b5a593" : "#847869"
        }

        font.pixelSize: 25
        background: Rectangle {
               implicitWidth: 130
               implicitHeight: 40
               color: "transparent"
        }
        //focusPolicy: Qt.NoFocus
        activeFocusOnTab: true
    }

    TextInput {
        id: input
        anchors.top: restartBtn.bottom
        anchors.topMargin: 30
        anchors.horizontalCenter: parent.horizontalCenter
        font.pixelSize: 30
        color: "#fae1c3"
        focus: true
        activeFocusOnTab: true
        cursorVisible: true
        onTextEdited: {
            if (parent.state === "testReady") {
                // start the test automatically
                // when the user starts typing
                parent.state = "testActive"
            }
            if (parent.state === "testActive") {
                // track progress and update test prompt
                typingTest.processKbInput(input.text)
            }

            // clear input field if the user finished typing the current word
            let pressedSpace = input.text.length > 0 && input.text.slice(-1) === " "
            if (pressedSpace) {
                input.text = ""
            }
        }

        /*MouseArea {
            anchors.fill: parent
            propagateComposedEvents: true

            onClicked: (event) => {
                console.log("clicked on TextInput");
                input.focus = true
                event.accepted = false;
            }
        }*/
    }
}
