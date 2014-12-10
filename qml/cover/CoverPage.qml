import QtQuick 2.0
import Sailfish.Silica 1.0

CoverBackground {
    BackgroundItem {
        anchors.fill: parent

        Image {
            id: coverBgImage
            anchors.fill: parent
            fillMode: Image.PreserveAspectFit
            source: "../images/coverbg.png"
            opacity: 0.2
            horizontalAlignment: Image.AlignHCenter
            verticalAlignment: Image.AlignVCenter
        }
    }
    Column {
        width: parent.width
        anchors.leftMargin: Theme.paddingLarge
        anchors.rightMargin: Theme.paddingLarge
        anchors.fill: parent
        anchors.margins: 15
        Label {
            text: dishText1
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignBottom
            width: parent.width
            font.pixelSize: Theme.fontSizeSmall
            color: Theme.primaryColor
        }
        Label {
            text: timeText1
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignBottom
            width: parent.width
            font.pixelSize: Theme.fontSizeHuge
            color: timer1running ? Theme.highlightColor : Theme.secondaryHighlightColor
        }
        Label {
            text: dishText2
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignBottom
            width: parent.width
            font.pixelSize: Theme.fontSizeSmall
            color: Theme.primaryColor
        }
        Label {
            text: timeText2
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignBottom
            width: parent.width
            font.pixelSize: Theme.fontSizeHuge
            color: timer2running ? Theme.highlightColor : Theme.secondaryHighlightColor
        }
        Label {
            text: dishText3
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignBottom
            width: parent.width
            font.pixelSize: Theme.fontSizeSmall
            color: Theme.primaryColor
        }
        Label {
            text: timeText3
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignBottom
            width: parent.width
            font.pixelSize: Theme.fontSizeHuge
            color: timer3running ? Theme.highlightColor : Theme.secondaryHighlightColor
        }
    }
}
