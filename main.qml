import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtCharts

import Qt.labs.qmlmodels 1.0

Window {
    width: 1000
    height: 800
    visible: true
    title: "qtypingtest"
    color: "#202020"
    id: root

    onClosing: testResultsModel.saveToFile("results.csv")

    TitleBar {
        id: titleBar
        anchors.top: parent.top
        width: parent.width
    }

    TabBar {
        id: tabBar
        anchors.top: titleBar.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        width: 640
        height: 40
        font.pixelSize: 24
        focusPolicy: Qt.NoFocus

        // draw line below tab buttons
        background: Rectangle {
            color: "#fae1c3"
            height: 2
            y: tabBar.y - 22
        }
        spacing: 5

        Repeater {
            model: ["test", "results", "info"]

            delegate: TabButton {
                width: implicitWidth
                function getButtonColor() {
                    if (tabBar.currentIndex === TabBar.index) {
                        return "#fae1c3"
                    } else {
                        return hovered ? "#b5a593" : "#847869"
                    }
                }
                icon.source: "qrc:/images/" + modelData + ".svg"
                icon.width: 24
                icon.height: 24
                icon.color: getButtonColor()
                display: AbstractButton.TextBesideIcon
                palette {
                    buttonText: getButtonColor()
                }
                text: modelData
                background: Rectangle {
                    color: "transparent"
                }
                focusPolicy: Qt.NoFocus
            }
        }
    }

    StackLayout {
        id: tabs
        width: parent.width
        height: 700
        currentIndex: tabBar.currentIndex
        anchors.top: tabBar.bottom
        anchors.topMargin: 20

        Item {
            id: testTab
            Layout.alignment: Qt.AlignHCenter
            TestInterface {
                id: testInterface
                anchors.horizontalCenter: parent.horizontalCenter
                testDuration: 5
                anchors.top: parent.top
            }
            DetailedTestResults {
                id: currentTestResults
                testDuration: testInterface.testDuration
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
        Item {
            id: resultsTab
            Layout.alignment: Qt.AlignHCenter
            width: 600
            Text {
                id: resultsTitle
                anchors.left: table.left
                color: "#c58940"
                font.pixelSize: 24
                text: "results"
            }
            TableView {
                id: table
                width: 600
                height: 480
                anchors.top: horizontalHeader.bottom
                anchors.horizontalCenter: parent.horizontalCenter
                columnSpacing: 2
                rowSpacing: 1
                clip: true
                boundsMovement: Flickable.StopAtBounds
                model: testResultsModel

                delegate: Rectangle {
                    color: (row % 2 === 0 ? "#2b2a2a": "transparent")
                    implicitWidth: column !== 3 ? 110 : 180
                    implicitHeight: 40

                    Text {
                        text: display
                        color: "#fae1c3"
                        font.pixelSize: 16
                        anchors.centerIn: parent
                    }
                }
                ScrollBar.vertical: ScrollBar {
                    active: true
                    policy: ScrollBar.AlwaysOn
                }
            }
            HorizontalHeaderView {
                boundsMovement: Flickable.StopAtBounds
                id: horizontalHeader
                model: [
                    "<u>wpm</u>", "<u>accuracy</u>", "<u>duration</u>", "<u>date/time</u>"
                ]
                textRole: "display"
                syncView: table
                anchors.left: table.left
                anchors.top: resultsTitle.bottom
                delegate: Rectangle {
                    implicitWidth: modelData === "<u>date/time</u>" ? 110 : 180
                    implicitHeight: 40
                    color: "transparent"
                    Text {
                        font.pixelSize: 20
                        color: "#847869"
                        text: modelData
                        anchors.centerIn: parent
                    }
                }
            }
        }
        Item {
            id: infoTab
            Text {
                id: info
                anchors.top: parent.top
                anchors.horizontalCenter: parent.horizontalCenter
                color: "#c58940"
                font.pixelSize: 60
                text: "info"
            }
        }
    }
}
