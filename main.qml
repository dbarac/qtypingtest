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

        TestResultsView {
            id: resultsTab
            Layout.alignment: Qt.AlignHCenter
        }

        Item {
            id: aboutTab
            Layout.alignment: Qt.AlignHCenter
            width: 640
            Text {
                id: about
                width: 640
                anchors.horizontalCenter: parent.horizontalCenter
                color: "#fae1c3"
                font.pixelSize: 18
                horizontalAlignment: Text.AlignLeft
                wrapMode: Text.WordWrap
                text: "<font color='#c58940'>general</font>" +
                      "<p>This is a typing test program inspired by the " +
                      "monkeytype.com website. The test is time limited (15, 30 or 60 seconds). " +
                      "Words for typing are sampled from a set of top 100 " +
                      "most common english words until the time runs out.</p> " +

                      "<font color='#c58940'>test metrics</font>" +
                      "<p>The program measures typed words per minute (WPM) and accuracy for " +
                      "each test. For WPM calculation, one word equals 5 keystrokes, like on " +
                      "most typing websites. Keystrokes are only counted if an entire word " +
                      "was typed correctly. Accuracy is calculated by dividing the number of currect " +
                      "keystrokes with the total number of keystrokes.</p>" +

                      "<font color='#c58940'>shortcuts</font>" +
                      "<p>While the test is running, focus can be shifted between the text input " +
                      "field and the restart button by pressing Tab. " +
                      "To restart while a test is running, press Tab+Enter. " +
                      "When time runs out, focus is shifted to the restart button and " +
                      "the test can be restarted by pressing Enter."
            }
        }
    }
}
