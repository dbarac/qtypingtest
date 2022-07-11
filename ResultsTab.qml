import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtCharts
import Qt.labs.qmlmodels 1.0

Item {
    width: 600
    Text {
        id: resultsTitle
        anchors.left: table.left
        color: "#c58940"
        font.pixelSize: 24
        text: "test results"
    }
    TableView {
        id: table
        width: 540
        height: 480
        anchors.top: horizontalHeader.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        columnSpacing: 2
        rowSpacing: 1
        clip: true
        boundsMovement: Flickable.StopAtBounds
        model: testResultsModel

        delegate: Rectangle {
            color: (row % 2 === 0 ? "#2b2a2a": "transparent")
            implicitWidth: column !== 3 ? 110 : 180
            implicitHeight: 40

            Text {
                text: display
                color: "#fae1c3"
                font.pixelSize: 16
                anchors.centerIn: parent
            }
        }
        ScrollBar.vertical: ScrollBar {
            active: true
            policy: ScrollBar.AlwaysOn
        }
    }
    HorizontalHeaderView {
        boundsMovement: Flickable.StopAtBounds
        id: horizontalHeader
        model: [
            "<u>wpm</u>", "<u>accuracy</u>", "<u>duration</u>", "<u>date/time</u>"
        ]
        textRole: "display"
        syncView: table
        anchors.left: table.left
        anchors.top: resultsTitle.bottom
        delegate: Rectangle {
            implicitWidth: modelData === "<u>date/time</u>" ? 110 : 180
            implicitHeight: 40
            color: "transparent"
            Text {
                font.pixelSize: 20
                color: "#847869"
                text: modelData
                anchors.centerIn: parent
            }
        }
    }
}
