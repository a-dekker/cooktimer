import QtQuick 2.0
import Sailfish.Silica 1.0

CoverBackground {
    property bool largeScreen: Screen.sizeCategory === Screen.Large
                               || Screen.sizeCategory === Screen.ExtraLarge
    BackgroundItem {
        anchors.fill: parent

        Image {
            id: coverBgImage
            anchors.fill: parent
            fillMode: Image.PreserveAspectFit
            source: mainapp.isLightTheme ? "../images/coverbg-rev.png" : "../images/coverbg.png"
            opacity: largeScreen ? 0.05 : 0.1
            horizontalAlignment: Image.AlignHCenter
            verticalAlignment: Image.AlignVCenter
            visible: mainapp.bg_image
        }
    }

    SilicaFlickable {
        width: parent.width
        anchors.leftMargin: Theme.paddingLarge
        anchors.rightMargin: Theme.paddingLarge
        anchors.fill: parent

        Label {
            id: dishname1
            text: dishText1
            horizontalAlignment: Text.AlignHCenter
            width: parent.width
            font.pixelSize: Theme.fontSizeSmall
            color: Theme.primaryColor
        }
        Label {
            id: dishtime1
            text: timeText1
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignTop
            width: parent.width
            font.pixelSize: Theme.fontSizeHuge
            color: timer1running ? Theme.highlightColor : Theme.secondaryHighlightColor
            anchors.topMargin: -Theme.paddingSmall
            anchors.bottomMargin: 0
            anchors.top: dishname1.bottom
        }
        ProgressBar {
            id: progressCoverBar1
            width: parent.width
            anchors.horizontalCenter: parent.horizontalCenter
            maximumValue: 1
            leftMargin: 0
            rightMargin: 0
            anchors.bottomMargin: 1
            anchors.topMargin: mainapp.isLightTheme ? - 2.5 * Theme.paddingLarge : - 2 * Theme.paddingLarge
            anchors.top: dishtime1.bottom
            value: mainapp.progressValue1
            height: Theme.paddingMedium
            visible: timer1running
        }

        Label {
            id: dishname2
            text: dishText2
            horizontalAlignment: Text.AlignHCenter
            width: parent.width
            font.pixelSize: Theme.fontSizeSmall
            color: Theme.primaryColor
            anchors.top: dishtime1.bottom
            anchors.topMargin: 0
        }
        Label {
            id: dishtime2
            text: timeText2
            horizontalAlignment: Text.AlignHCenter
            width: parent.width
            anchors.topMargin: -Theme.paddingSmall
            font.pixelSize: Theme.fontSizeHuge
            color: timer2running ? Theme.highlightColor : Theme.secondaryHighlightColor
            anchors.top: dishname2.bottom
        }
        ProgressBar {
            id: progressCoverBar2
            width: parent.width
            anchors.horizontalCenter: parent.horizontalCenter
            maximumValue: 1
            leftMargin: 0
            rightMargin: 0
            anchors.topMargin: mainapp.isLightTheme ? - 2.5 * Theme.paddingLarge : - 2 * Theme.paddingLarge
            anchors.bottomMargin: 1
            anchors.top: dishtime2.bottom
            value: mainapp.progressValue2
            height: Theme.paddingMedium
            visible: timer2running
        }
        Label {
            id: dishname3
            text: dishText3
            horizontalAlignment: Text.AlignHCenter
            width: parent.width
            font.pixelSize: Theme.fontSizeSmall
            color: Theme.primaryColor
            anchors.top: dishtime2.bottom
            anchors.topMargin: -Theme.paddingSmall
        }
        Label {
            id: dishtime3
            text: timeText3
            anchors.topMargin: -Theme.paddingSmall
            horizontalAlignment: Text.AlignHCenter
            width: parent.width
            font.pixelSize: Theme.fontSizeHuge
            color: timer3running ? Theme.highlightColor : Theme.secondaryHighlightColor
            anchors.top: dishname3.bottom
        }
        ProgressBar {
            id: progressCoverBar3
            width: parent.width
            anchors.horizontalCenter: parent.horizontalCenter
            maximumValue: 1
            leftMargin: 0
            rightMargin: 0
            anchors.topMargin: mainapp.isLightTheme ? - 2.5 * Theme.paddingLarge : - 2 * Theme.paddingLarge
            anchors.bottomMargin: 1
            anchors.top: dishtime3.bottom
            value: mainapp.progressValue3
            height: Theme.paddingMedium
            visible: timer3running
        }
    }
    CoverActionList {
        id: coverAction

        CoverAction {
            iconSource: timer1running ? (mainapp.isLightTheme ? "../images/icon-cover-stop-rev.png" : "../images/icon-cover-stop.png") : "image://theme/icon-cover-play"
            onTriggered: {
                mainPage.toggleTimer1()
            }
        }
        CoverAction {
            iconSource: timer2running ? (mainapp.isLightTheme ? "../images/icon-cover-stop-rev.png" : "../images/icon-cover-stop.png") : "image://theme/icon-cover-play"
            onTriggered: {
                mainPage.toggleTimer2()
            }
        }
        CoverAction {
            iconSource: timer3running ? (mainapp.isLightTheme ? "../images/icon-cover-stop-rev.png" : "../images/icon-cover-stop.png") : "image://theme/icon-cover-play"
            onTriggered: {
                mainPage.toggleTimer3()
            }
        }
    }
}
