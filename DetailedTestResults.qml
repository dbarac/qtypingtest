import QtQuick 2.0
import QtCharts

Rectangle {
    required property int testDuration
    color: "#202020" //"#847869"
    width: 640
    height: 300
    property int wpm: 0
    property int accuracy: 0

    Text {
        id: finalResults
        text: "wpm: <font color='#91170c'>" + wpm + "</font> " +
              "accuracy: <font color='#91170c'>" + accuracy + "</font>"
        font.pixelSize: 30
        color: "#847869"
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
    }

    function appendToWPMSeries(time, wpm) {
        wpmSeries.append(time, wpm)
    }

    function clearWPMSeries() {
        // remove all points
        wpmSeries.removePoints(0, wpmSeries.count)
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
            id: wpmSeries
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
                max: testDuration//wpmSeries.count
                //tickInterval: testDuration
                tickCount: testDuration //wpmSeries.count//
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
                    for (let i = 0; i < wpmSeries.count; i++) {
                        let wpm = wpmSeries.at(i).y
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
