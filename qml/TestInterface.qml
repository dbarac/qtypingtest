import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Item {
    id: testInterface
    implicitHeight: 630
    state: "testReady"
    property int testDuration: 5
    property int nextTestDuration: 5
    property int remainingTime: testDuration

    states: [
        State { name: "testReady"
            PropertyChanges { target: hintRect; opacity: 1.0 }
            PropertyChanges { target: currentTestResults; opacity: 0.0 }
            PropertyChanges { target: remainingTimeStr; opacity: 1.0 }
        },
        State { name: "testActive"
            PropertyChanges { target: hintRect; opacity: 0.0 }
        },
        State { name: "testFinished"
            PropertyChanges { target: restartButton; focus: true }
            PropertyChanges { target: hintRect; opacity: 0.0 }
            PropertyChanges { target: currentTestResults; opacity: 1.0 }
            PropertyChanges { target: remainingTimeStr; opacity: 0.0 }
        }
    ]
    transitions: Transition {
        NumberAnimation { target: hintRect; property: "opacity"; duration: 250 }
        NumberAnimation { target: currentTestResults; property: "opacity"; duration: 250 }
        NumberAnimation { target: remainingTimeStr; property: "opacity"; duration: 250 }
    }

    function finishTest() {
        testInterface.state = "testFinished"
        testInput.clear()
    }

    function restartTest() {
            testInterface.testDuration = testInterface.nextTestDuration
            remainingTime = testInterface.testDuration
            testInterface.state = "testReady"
            testInput.text = ""
            testInput.focus = true
            typingTest.reset()
    }

    Timer {
        id: testTimer
        interval: 1000;
        repeat: true
        running: testInterface.state === "testActive"
        onTriggered: {
            // clear old results when a new test starts
            if (testInterface.remainingTime === testInterface.testDuration) {
                currentTestResults.clearWPMSeries()
            }

            testInterface.remainingTime--

            // log current WPM for displaying in a chart after test ends
            let currentTime = testInterface.testDuration - testInterface.remainingTime
            let wpm = typingTest.calculateWPM(currentTime)
            currentTestResults.appendToWPMSeries(currentTime, wpm)

            // save results when test is finished
            if (testInterface.remainingTime === 0) {
                let acc = typingTest.calculateAccuracy();
                testResultsModel.appendEntry(wpm, acc, testInterface.testDuration)
                testInterface.finishTest()

                currentTestResults.testDuration = testInterface.testDuration
                currentTestResults.wpm = wpm
                currentTestResults.accuracy = acc
            }
        }
    }

    RadioSelector {
        id: durationRadioButtons
        anchors.top: parent.top
        anchors.left: testPrompt.left
        propertyName: "duration:"
        possibleValues: ["5", "15", "30", "60"]
        defaultValue: "5"
        onButtonClicked: (duration) => {
            testInterface.nextTestDuration = parseInt(duration)
            if (testInterface.state === "testReady") {
                testInterface.testDuration = testInterface.nextTestDuration
                testInterface.remainingTime = testInterface.testDuration
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
        onClicked: restartTest()
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
            if (testInterface.state === "testReady") {
                // start the test automatically
                // when the user starts typing
                testInterface.state = "testActive"
            }
            if (testInterface.state === "testActive") {
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

    DetailedTestResults {
        id: currentTestResults
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: restartButton.bottom
        anchors.topMargin: 20
        opacity: 0
    }
}
