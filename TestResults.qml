import QtQuick 2.0
import QtCharts

Rectangle {
    property alias wpmacc: wpmacc.text
    //id: resultsRect
    //anchors.top: testInterface.bottom
    color: "#202020" //"#847869"
    //border.color: "#847869"
    //border.width: 2
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

    //TestResultsChartView {
    //    id: resultsChart
    //    anchors.fill: parent
    //    anchors.top: wpmacc.bottom
    //}

    ChartView {
        title: "Test results"
        titleFont.pixelSize: 22
        titleFont.bold: true
        titleColor: "#847869"
        antialiasing: true
        anchors.fill: parent
        legend.visible: false
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
                titleText:"<font color='#847869'>Current WPM</font>"
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
