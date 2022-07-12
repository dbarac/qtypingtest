import QtQuick 2.0
import QtCharts

Item {
    property int testDuration: 15
    property int wpm: 0
    property int accuracy: 0

    implicitWidth: 640
    implicitHeight: 300

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
        id: wpmChart
        antialiasing: true
        anchors.fill: parent
        anchors.topMargin: 10
        legend.visible: false
        backgroundColor: "transparent"

        LineSeries {
            id: wpmSeries
            name: "wpm"
            color: "#91170c"
            width: 3

            axisX: ValueAxis {
                color: "#61584e"
                labelsColor: "#847869"
                labelsFont.pixelSize: 14
                labelsFont.bold: true
                gridLineColor: "#61584e"
                titleText: "<font color='#847869'>Time (s)</font>"
                min: 1
                max: testDuration
                tickCount: 15
                labelFormat: "%d"
            }

            axisY: ValueAxis {
                color: "#61584e"
                labelsColor: "#847869"
                labelsFont.pixelSize: 14
                labelsFont.bold: true
                gridLineColor: "#61584e"
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
