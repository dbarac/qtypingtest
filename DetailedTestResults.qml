import QtQuick 2.0
import QtCharts

Rectangle {
    property alias wpmacc: wpmacc.text
    required property int testDuration
    color: "#202020" //"#847869"
    width: 640
    height: 300

    Text {
        id: wpmacc
        text: root.wpmacc//"wpm: 107 accuracy: 80%"
        font.pixelSize: 30
        color: "#91170c"
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
    }

    function appendToWPMSeries(time, wpm) {
        series.append(time, wpm)
    }

    function clearResults() {
        // remove all points
        series.removePoints(0, series.count)
    }

    ChartView {
        id: resultsChart
        title: "Test results"
        titleFont.pixelSize: 22
        titleFont.bold: true
        titleColor: "#847869"
        antialiasing: true
        anchors.fill: parent
        legend.visible: false
        backgroundColor: "transparent"

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
                titleText: "<font color='#847869'>Time (s)</font>"
                min: 1
                max: testDuration
                //tickInterval: testDuration
                tickCount: testDuration
                labelFormat: "%d"
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
        }
    }
}
