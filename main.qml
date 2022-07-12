import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

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
            model: ["test", "results", "about"]

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

        TestTab {
            id: testTab
            Layout.alignment: Qt.AlignHCenter
        }

        ResultsTab {
            id: resultsTab
            Layout.alignment: Qt.AlignHCenter
        }

        Item {
            id: aboutTab
            Text {
                id: about
                anchors.top: parent.top
                anchors.horizontalCenter: parent.horizontalCenter
                color: "#c58940"
                font.pixelSize: 60
                text: "about"
            }
        }
    }
}
