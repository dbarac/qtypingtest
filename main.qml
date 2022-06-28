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
        Layout.alignment: Qt.AlignHCenter
        //width: 800

        Item {
            id: testTab
            Layout.alignment: Qt.AlignHCenter
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

             // fade-in and fade-out, depending on current testActive value
             property bool stateVisible: !testInterface.testActive
             onStateVisibleChanged: {
                 console.log("now chagned")
             }

             states: [
                 State { when: testTab.stateVisible;
                     PropertyChanges { target: resultsRect; opacity: 1.0 }
                 },
                 State { when: !testTab.stateVisible;
                     PropertyChanges { target: resultsRect; opacity: 0.0 }
                 }
             ]
             transitions: Transition {
                 NumberAnimation { property: "opacity"; duration: 250}
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
