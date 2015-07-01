import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    id: page
    SilicaFlickable {
        anchors.fill: parent
        contentWidth: parent.width
        contentHeight: col.height

        VerticalScrollDecorator {
        }

        Column {
            id: col
            spacing: Theme.paddingLarge
            width: parent.width
            PageHeader {
                title: qsTr("About")
            }
            SectionHeader {
                text: qsTr("Info")
            }
            Rectangle {
                color: "#999999"
                x: Theme.paddingLarge * 3
                width: parent.width - Theme.paddingLarge * 3 * 2
                height: 2
                anchors.leftMargin: 20
                anchors.topMargin: 30
            }
            Label {
                text: "cooktimer"
                font.pixelSize: Theme.fontSizeExtraLarge
                anchors.horizontalCenter: parent.horizontalCenter
            }
            Rectangle {
                width: 80
                height: width
                radius: 100
                anchors.horizontalCenter: parent.horizontalCenter
                NumberAnimation on rotation
                {
                    from: 0
                    to: 360
                    duration: 5000
                    loops: 1
                }
                Image {
                   source: "/usr/share/icons/hicolor/86x86/apps/cooktimer.png"
                }
            }
            Label {
                text: qsTr("Version") + " " + version
                anchors.horizontalCenter: parent.horizontalCenter
                color: Theme.secondaryHighlightColor
            }
            Label {
                text: qsTr("\"Timers for cooking\"")
                font.pixelSize: Theme.fontSizeSmall
                anchors.horizontalCenter: parent.horizontalCenter
                color: Theme.secondaryColor
            }
            SectionHeader {
                text: qsTr("Author")
            }
            Rectangle {
                color: "#999999"
                x: Theme.paddingLarge * 3
                width: parent.width - Theme.paddingLarge * 3 * 2
                height: 2
                anchors.leftMargin: 20
                anchors.topMargin: 30
            }
            Label {
                text: "© Arno Dekker 2014-2015"
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }
    }
}
