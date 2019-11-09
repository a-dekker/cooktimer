import QtQuick 2.0
import Sailfish.Silica 1.0

DockedPanel {
    id: dishInfoPanel

    property string comment
    property string dish

    width: parent.width
    height: infoColumn.height + 2 * Theme.paddingMedium
    contentHeight: height
    dock: Dock.Bottom



    function showDishInfo() {
        if (expanded) {
            hide()
        } else {
            show()
        }
    }

    MouseArea {
        anchors.fill: parent
        onClicked: hide()
    }

    property int _headerWidth: 125
    property int _textWidth: width - _headerWidth - Theme.paddingLarge



    Rectangle {
        anchors.fill: parent
        color: Theme.rgba(Theme.primaryHighlightColor, 0.7)

        Image {
            width: parent.width
            source: "image://theme/graphic-system-gradient"
        }

        Column {
            id: infoColumn
            spacing: Theme.paddingMedium
            anchors.centerIn: parent

            Label {
                id: dishLabel
                text: dish
                color: Theme.secondaryColor
                width: parent.width - 2 * Theme.paddingMedium
                font.pixelSize: Theme.fontSizeMedium
                horizontalAlignment: Text.AlignHCenter
                anchors.horizontalCenter: parent.horizontalCenter
            }
            Separator {
                color: Theme.primaryColor
                width: parent.width
                opacity: mainapp.isLightTheme ? 0.8 : 0.5
                anchors.horizontalCenter: parent.horizontalCenter
                horizontalAlignment: Qt.AlignHCenter
            }
            Label {
                id: commentLabel
                text: comment
                font.pixelSize: Theme.fontSizeMedium
                truncationMode: TruncationMode.Fade
                anchors.horizontalCenter: parent.horizontalCenter
                width: _textWidth
            }
        }
    }
}
