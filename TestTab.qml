import QtQuick
import QtQuick.Layouts

Item {

    TestInterface {
        id: testInterface
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
    }

    DetailedTestResults {
        id: currentTestResults
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: testInterface.bottom
        opacity: 0
    }

    Timer {
        id: timer
        interval: 1000;
        repeat: true
        running: testInterface.state === "testActive"
        onTriggered: {
            // clear old results when a new test starts
            if (testInterface.remainingTime === testInterface.testDuration) {
                currentTestResults.clearWPMSeries()
            }

            testInterface.updateRemainingTime()
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

    // fade-in/out for test results
    states: [
        State { when: testInterface.state === "testFinished";
            PropertyChanges { target: currentTestResults; opacity: 1.0 }
        },
        State { when: testInterface.state !== "testFinished";
            PropertyChanges { target: currentTestResults; opacity: 0.0 }
        }
    ]
    transitions: Transition {
        NumberAnimation { target: currentTestResults; property: "opacity"; duration: 250 }
    }
}
