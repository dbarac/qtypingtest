import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtCharts

Window {
    width: 1000
    height: 800
    visible: true
    title: "qtypetest"
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
        text: "qtypetest"
        font.bold: false
        font.pixelSize: 35
    }

    Rectangle {
        id: inputbox
        //y: title.y + kb.height + 20
        width: parent.width; height: 300
        anchors.top: bar.bottom
        anchors.topMargin: 20
        color: "#202020"
        //color: "#4A4A40" boja za debug
        property bool testActive: false

        Text {
            id: remainingTime
            anchors.horizontalCenter: parent.horizontalCenter
            width: root.width - 200
            color: inputbox.testActive ?  "#c58940" : "#847869"//"#7ebab5"
            horizontalAlignment: Text.AlignHCenter
            text: "5"
            font.pixelSize: 60
            wrapMode: Text.WordWrap
        }

        Timer {
            id: timer
            interval: 1000;
            repeat: true
            running: false
            onTriggered: function updateRemainingTime() {
                let remaining = parseInt(remainingTime.text)
                //console.log(remainingTime.text)
                if (remaining > 1) {
                    remaining--
                } else {
                    remaining = 5
                    timer.stop()
                    inputbox.testActive = false
                    root.wpmacc = "WPM: " + typingTest.calculateWPM(5) +
                                  " Accuracy: " + typingTest.calculateAccuracy() + "%"
                }
                remainingTime.text = remaining.toString()
            }
        }

        Text {
            id: testText
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: remainingTime.bottom
            width: 640//root.width - 200
            color: "#847869"//"white"
            horizontalAlignment: Text.AlignHCenter

            //FontLoader { id: plex; source: "qrc:/fonts/IBMPlexMono-Regular.ttf" }
            //font.family: plex.name

            text: typingTest.guiTestStr;
            font.pixelSize: 23
            wrapMode: Text.WordWrap
            //focus: true
            Keys.onPressed: function logPressedKey(event) {
                console.log("pressed " + String.fromCharCode(event.key).toLowerCase())
            }
            //Keys.onEscapePressed: {
            //    label.text = ''
            //}
        }

        Button {
            id: restartBtn
            anchors.top: testText.bottom
            anchors.topMargin: 30
            anchors.horizontalCenter: parent.horizontalCenter
            text: "Restart"

            icon.source: "qrc:/images/arrow-rotate-right-solid.svg"
            icon.width: 24
            icon.height: 24
            //icon.color: getButtonColor()
            display: AbstractButton.TextBesideIcon

            //onClicked: typingTest.doSomething("TEXT FROM QML")
            onClicked: {
                remainingTime.text = "5"
                inputbox.testActive = false
                timer.stop()
                input.text = ""
                root.wpmacc = ""
                typingTest.sampleWordDataset()
                typingTest.updateGuiTestStr(true)
            }
            font.pixelSize: 25
            background: Rectangle {
                   implicitWidth: 130
                   implicitHeight: 40
                   color: "#c58940"//"#847869"//button.down ? "#d6d6d6" : "#f6f6f6"
                   border.color: "#26282a"
                   border.width: 1
                   radius: 10
            }
            focusPolicy: Qt.NoFocus
        }

        TextInput {
            id: input
            anchors.top: restartBtn.bottom
            anchors.topMargin: 30
            anchors.horizontalCenter: parent.horizontalCenter
            font.pixelSize: 30
            color: "#fae1c3"
            //text: "Text"
            focus: true
            cursorVisible: true
            onTextEdited: {
                if (!parent.testActive) {
                    parent.testActive = true;
                    timer.start()
                    root.wpmacc = ""
                }
                /*
                let shouldClearInput = typingTest.processKbInput(input.text)
                if (shouldClearInput) {
                    input.text = ""
                }*/
                typingTest.processKbInput(input.text)
                let pressedSpace = input.text.length > 0 && input.text.slice(-1) === " "
                if (pressedSpace) {
                    input.text = ""
                }
            }
        }
    }

    Rectangle {
        property alias wpmacc: wpmacc.text
        id: resultsRect
        anchors.top: inputbox.bottom
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
            anchors.top: inputbox.bottom
            anchors.horizontalCenter: parent.horizontalCenter
        }


        ChartView {
            title: "Test results"
            titleFont.pixelSize: 22
            //titleFont.bold: true
            titleColor: "#847869"

            anchors.top: wpmacc.bottom
            anchors.fill: parent
            antialiasing: true
            legend.visible: false
            //width: 640//wpmacc.width
            //height: 200//wpmacc.height
            backgroundColor: "transparent"
            theme: ChartView.ChartThemeBrownSand

            LineSeries {
                id: series
                name: "LineSeries"
                color: "#91170c"
                width: 3
                axisX: ValueAxis {
                    color: "#847869"
                    labelsColor: "#847869"
                    labelsFont.pixelSize: 14
                    labelsFont.bold: true
                    gridLineColor: "#847869"
                    titleText:"<font color='#847869'>Time (s)</font>"
                }
                axisY: ValueAxis {
                    color: "#847869"
                    labelsColor: "#847869"
                    labelsFont.pixelSize: 14
                    labelsFont.bold: true
                    gridLineColor: "#847869"
                    min: 0
                    max: {
                        let max = 0
                        for (let i = 0; i < series.count; i++) {
                            let wpm = series.at(i).y
                            if (wpm > max) {
                                max = wpm
                            }
                        }
                        return max
                    }
                    //titleText: "Current WPM"
                    titleText:"<font color='#847869'>Current WPM</font>"
                    //titleBrush:  "#847869"
                }
                XYPoint { x: 1; y: 70 }
                XYPoint { x: 2; y: 72 }
                XYPoint { x: 3; y: 68 }
                XYPoint { x: 4; y: 75 }
                XYPoint { x: 5; y: 80 }
                XYPoint { x: 6; y: 82 }
                XYPoint { x: 7; y: 68 }
                XYPoint { x: 8; y: 84 }
                XYPoint { x: 9; y: 88 }
                XYPoint { x: 10; y: 90 }
                XYPoint { x: 11; y: 92 }
                XYPoint { x: 12; y: 78 }
                XYPoint { x: 13; y: 95 }
                XYPoint { x: 14; y: 105 }
                XYPoint { x: 15; y: 107 }
            }
        }
    }

    TabBar {
        //anchors.top: resultsRect.bottom
        y: title.y + kb.height + 20
        anchors.horizontalCenter: parent.horizontalCenter
        id: bar
        width: resultsRect.width
        font.pixelSize: 24

        // draw line below tabs
        background: Rectangle {
            color: "#fae1c3"//"transparent"
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

    /*StackLayout {
        width: parent.width
        currentIndex: bar.currentIndex
        anchors.top: bar.bottom
        Item {
            id: homeTab
            Rectangle {
                id: redrect
                color: "red"
                width: 100
                height: 100
            }
        }
        Item {
            id: discoverTab
        }
        Item {
            id: activityTab
        }
    }*/
}
