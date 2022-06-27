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

    /*TypingTest {
        id: testInterface
        testDuration: 7
        anchors.top: bar.bottom
    }

    Rectangle {
        property alias wpmacc: wpmacc.text
        id: resultsRect
        anchors.top: testInterface.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        color: "#202020" //"#847869"
        border.color: "#847869"
        border.width: 2
        width: 640
        height: 300
        //y: inputbox.height

        Text {
            id: wpmacc
            text: root.wpmacc//"wpm: 107 accuracy: 80%"
            font.pixelSize: 30
            color: "#91170c"
            anchors.top: testInterface.bottom
            anchors.horizontalCenter: parent.horizontalCenter
        }

        TestResultsChartView {
            id: resultsChart
            anchors.fill: parent
            anchors.top: wpmacc.bottom
        }
    }*/

    TabBar {
        //anchors.top: resultsRect.bottom
        y: title.y + kb.height + 20
        anchors.horizontalCenter: parent.horizontalCenter
        id: bar
        width: 640
        font.pixelSize: 24

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
        Layout.alignment: Qt.AlignHCenter
        //width: 800

        Item {
            id: testTab
            Layout.alignment: Qt.AlignHCenter
            //anchors.horizontalCenter: parent.horizontalCenter
            /*Rectangle {
            anchors.horizontalCenter: parent.horizontalCenter
                id: redrect
                color: "red"
                width: 100
                height: 100
            }*/
            TypingTest {
                id: testInterface
                anchors.horizontalCenter: parent.horizontalCenter
                testDuration: 15
                anchors.top: parent.top
            }
            TestResults {
                id: resultsRect
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: testInterface.bottom
            }
            /*Rectangle {
                property alias wpmacc: wpmacc.text
                id: resultsRect
                anchors.top: testInterface.bottom
                anchors.horizontalCenter: parent.horizontalCenter
                color: "#202020" //"#847869"
                border.color: "#847869"
                border.width: 2
                width: 640
                height: 300
                //y: inputbox.height

                Text {
                    id: wpmacc
                    text: root.wpmacc//"wpm: 107 accuracy: 80%"
                    font.pixelSize: 30
                    color: "#91170c"
                    anchors.top: parent.top
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                TestResultsChartView {
                    id: resultsChart
                    anchors.fill: parent
                    anchors.top: wpmacc.bottom
                }
            }*/
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
