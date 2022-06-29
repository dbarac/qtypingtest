import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtCharts

Window {
    width: 1000
    height: 800
    visible: true
    title: "qtypingtest"
    color: "#202020"
    id: root

    //onActiveFocusItemChanged: print("activeFocusItem", activeFocusItem)
    property string wpmacc: ""

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
        text: "qtypingtest"
        font.bold: false
        font.pixelSize: 35
    }

    TabBar {
        //anchors.top: resultsRect.bottom
        y: title.y + kb.height + 20
        anchors.horizontalCenter: parent.horizontalCenter
        id: bar
        width: 640
        font.pixelSize: 24
        focusPolicy: Qt.NoFocus

        // draw line below tab buttons
        background: Rectangle {
            color: "#fae1c3"
            height: 2
            y: bar.y - 26
        }
        spacing: 5

        Repeater {
            model: ["test", "results", "info"]

            delegate: TabButton {
                width: implicitWidth
                function getButtonColor() {
                    if (bar.currentIndex === TabBar.index) {
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
        currentIndex: bar.currentIndex
        //anchors.top: bar.bottom
        y: bar.y + bar.height + 40
        //anchors.horizontalCenter: parent.horizontalCenter
        //Layout.alignment: Qt.AlignHCenter
        //width: 800

        Item {
            id: testTab
            Layout.alignment: Qt.AlignHCenter
            //anchors.horizontalCenter: parent.horizontalCenter
            TypingTest {
                id: testInterface
                anchors.horizontalCenter: parent.horizontalCenter
                testDuration: 10
                anchors.top: parent.top
            }
            TestResults {
                id: resultsRect
                testDuration: 10
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
                        resultsRect.clearResults()
                    }

                    // log current WPM for displaying in a chart after test ends
                    console.log(testInterface.testDuration)
                    //let remaining = parseInt(testInterface.remainingTime.text)
                    let currentTime = testInterface.testDuration - testInterface.remainingTime + 1
                    console.log(currentTime)
                    let wpm = typingTest.calculateWPM(currentTime)
                    console.log("entry ", currentTime, wpm)
                    resultsRect.appendToWPMSeries(currentTime, wpm)

                    testInterface.updateRemainingTime()
                }
            }

            // fade-in and fade-out, depending on current testActive value
            //property bool stateVisible: !testInterface.testActive
            //onStateVisibleChanged: {
            //    console.log("now chagned")
            //}

            states: [
                State { when: testInterface.state === "testFinished";
                    PropertyChanges { target: resultsRect; opacity: 1.0 }
                },
                State { when: testInterface.state !== "testFinished";
                    PropertyChanges { target: resultsRect; opacity: 0.0 }
                }
            ]
            transitions: Transition {
                NumberAnimation { target: resultsRect; property: "opacity"; duration: 250 }
            }
        }
        Item {
            id: resultsTab
            Text {
                anchors.top: parent.top
                anchors.horizontalCenter: parent.horizontalCenter
                color: "#c58940"
                font.pixelSize: 60
                text: "results"
            }
        }
        Item {
            id: infoTab
            Text {
                anchors.top: parent.top
                anchors.horizontalCenter: parent.horizontalCenter
                color: "#c58940"
                font.pixelSize: 60
                text: "info"
            }
        }
    }
}
