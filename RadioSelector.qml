import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

RowLayout {
    required property string propertyName
    required property string defaultValue
    required property var possibleValues
    required property var onButtonClicked

    Text {
        text: propertyName
        font.pixelSize: 20
        color: "#847869"
    }

    Repeater {
        model: possibleValues
        delegate: RadioButton {
            id: optionButton
            focusPolicy: Qt.NoFocus
            checked: modelData === defaultValue
            text: modelData
            spacing: 5

            onClicked: onButtonClicked(modelData)

            contentItem: Text {
                function getButtonColor() {
                    if (checked) {
                        return "#c58940"
                    } else {
                        return hovered ? "#b5a593" : "#847869"
                    }
                }
                text: optionButton.text
                font.pixelSize: 20
                opacity: enabled ? 1.0 : 0.3
                color: getButtonColor()
                verticalAlignment: Text.AlignVCenter
            }
            indicator: Item {
                // empty
            }
        }
    }
}
