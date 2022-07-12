import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtCharts
import Qt.labs.qmlmodels 1.0

Item {
    width: 600

    RadioSelector {
        id: durationSelector
        anchors.left: resultsTable.left
        propertyName: "duration:"
        possibleValues: ["all", "5", "15", "30", "60"]
        defaultValue: "all"
        onButtonClicked: (value) => {
            if (value === "all") {
                // show all results
                resultsProxyModel.setFilterDuration(0)
            } else {
                // show results only for chosen test duration
                resultsProxyModel.setFilterDuration(parseInt(value))
            }
        }
    }

    RadioSelector {
        id: sortBySelector
        anchors.top: durationSelector.bottom
        anchors.left: resultsTable.left
        propertyName: "sort by:"
        possibleValues: ["wpm", "accuracy", "date/time"]
        defaultValue: "date/time"
        onButtonClicked: (value) => {
            switch (value) {
            case "wpm":
                resultsProxyModel.sort(0, resultsProxyModel.sortOrder())
                break;
            case "accuracy":
                resultsProxyModel.sort(1, resultsProxyModel.sortOrder())
                break;
            case "date/time":
                resultsProxyModel.sort(3, resultsProxyModel.sortOrder())
                break;
            }
        }
    }

    RadioSelector {
        id: orderSelector
        anchors.top: sortBySelector.bottom
        anchors.left: resultsTable.left
        propertyName: "order:"
        possibleValues: ["ascending", "descending"]
        defaultValue: "descending"
        onButtonClicked: (value) => {
            if (value === "ascending") {
                resultsProxyModel.sort(resultsProxyModel.sortColumn(), Qt.AscendingOrder)
            } else {
                resultsProxyModel.sort(resultsProxyModel.sortColumn(), Qt.DescendingOrder)
            }
        }
    }

    HorizontalHeaderView {
        id: resultsTableHeader
        syncView: resultsTable
        anchors.left: resultsTable.left
        anchors.top: orderSelector.bottom
        anchors.topMargin: 20
        boundsMovement: Flickable.StopAtBounds
        delegate: Rectangle {
            implicitWidth: column !== 3 ? 110 : 180
            implicitHeight: 40
            color: "transparent"
            Text {
                font.pixelSize: 20
                color: "#847869"
                text: display
                anchors.centerIn: parent
            }
        }
    }

    TableView {
        id: resultsTable
        width: 540
        height: 480
        anchors.top: resultsTableHeader.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        columnSpacing: 2
        rowSpacing: 1
        clip: true
        boundsMovement: Flickable.StopAtBounds
        model: resultsProxyModel

        delegate: Rectangle {
            color: row % 2 === 0 ? "#2b2a2a": "transparent"
            implicitWidth: column !== 3 ? 110 : 180
            implicitHeight: 40

            Text {
                // handle date formatting
                text: column === 3 ? display.toLocaleString(Qt.locale(), "yyyy/MM/dd hh:mm:ss")
                                   : display
                color: "#fae1c3"
                font.pixelSize: 16
                anchors.centerIn: parent
            }
        }
        ScrollBar.vertical: ScrollBar {
            active: true
            //policy: ScrollBar.AlwaysOn
        }
    }
}
