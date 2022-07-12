import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Item {
    id: testInterface
    width: parent.width; height: 330
    state: "testReady"
    property int testDuration: 15
    property int nextTestDuration: 15
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
            PropertyChanges { target: restartButton; focus: true }
        }
    ]
    transitions: Transition {
        NumberAnimation { target: hintRect; property: "opacity"; duration: 250 }
    }

    RowLayout {
        id: durationRadioButtons
        anchors.top: parent.top
        anchors.left: testPrompt.left
        Text {
            text: "duration:"
            font.pixelSize: 22
            color: "#847869"
        }

        Repeater {
            model: ["5", "15", "30", "60"]
            delegate: RadioButton {
                id: durationButton
                focusPolicy: Qt.NoFocus
                checked: modelData === "15"
                text: modelData
                spacing: 5

                onClicked: {
                    testInterface.nextTestDuration = parseInt(text)
                    if (testInterface.state === "testReady") {
                        testInterface.testDuration = testInterface.nextTestDuration
                        testInterface.remainingTime = testInterface.testDuration
                    }
                }

                contentItem: Text {
                    function getButtonColor() {
                        if (checked) {
                            return "#c58940"
                        } else {
                            return hovered ? "#b5a593" : "#847869"
                        }
                    }
                    text: durationButton.text
                    font.pixelSize: 22
                    opacity: enabled ? 1.0 : 0.3
                    color: getButtonColor()
                    verticalAlignment: Text.AlignVCenter
                }
                indicator: Item {
                    // empty
                }
            }
        }
    }

    Text {
        id: remainingTimeStr
        anchors.top: durationRadioButtons.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        color: testInterface.state === "testActive" ?  "#c58940" : "#847869"
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
        testInterface.state = "testFinished"
        testInput.clear()
    }

    // test prompt - words which the user should type
    Text {
        id: testPrompt
        anchors.topMargin: 10
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: hintRect.bottom
        width: 640
        height: 80
        color: "#847869"
        horizontalAlignment: Text.AlignHCenter
        text: typingTest.testPrompt;
        font.pixelSize: 23
        wrapMode: Text.WordWrap
    }

    Button {
        id: restartButton
        anchors.top: testPrompt.bottom
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
            testInterface.testDuration = testInterface.nextTestDuration
            remainingTime = parent.testDuration
            testInterface.state = "testReady"
            testInput.text = ""
            testInput.focus = true
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
        activeFocusOnTab: true
    }

    TextInput {
        id: testInput
        anchors.top: restartButton.bottom
        anchors.topMargin: 30
        anchors.horizontalCenter: parent.horizontalCenter
        font.pixelSize: 30
        color: "#fae1c3"
        focus: true
        activeFocusOnTab: true
        visible: parent.state !== "testFinished"
        onTextEdited: {
            if (parent.state === "testReady") {
                // start the test automatically
                // when the user starts typing
                parent.state = "testActive"
            }
            if (parent.state === "testActive") {
                // track progress and update test prompt
                typingTest.processKbInput(testInput.text)
            }

            // clear input field if the user finished typing the current word
            let pressedSpace = testInput.text.length > 0 && testInput.text.slice(-1) === " "
            if (pressedSpace) {
                testInput.text = ""
            }
        }
    }
}
