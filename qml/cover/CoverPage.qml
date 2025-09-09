import QtQuick 2.5
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

    Timer {
        id: coverblinktimer1
        interval: 1000
        running: isPaused1 && Cover.Active
        repeat: true
        onTriggered: dishtime1.opacity = dishtime1.opacity === 0 ? 1 : 0
        onRunningChanged: {
            if (!running) {
                dishtime1.opacity = 1
            }
        }
    }

    Timer {
        id: coverblinktimer2
        interval: 1000
        running: isPaused2 && Cover.Active
        repeat: true
        onTriggered: dishtime2.opacity = dishtime2.opacity === 0 ? 1 : 0
        onRunningChanged: {
            if (!running) {
                dishtime2.opacity = 1
            }
        }
    }

    Timer {
        id: coverblinktimer3
        interval: 1000
        running: isPaused3 && Cover.Active
        repeat: true
        onTriggered: dishtime3.opacity = dishtime3.opacity === 0 ? 1 : 0
        onRunningChanged: {
            if (!running) {
                dishtime3.opacity = 1
            }
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
        Item {
            id: dish1
            anchors.topMargin: -Theme.paddingSmall
            anchors.bottomMargin: 0
            anchors.top: dishname1.bottom
            width: parent.width
            height: dishtime1.height
            Rectangle {
                height: dishtime1.height
                width: parent.width * mainapp.progressValue1
                radius: 10
                visible: timer1running || isPaused1
                anchors.verticalCenter: dishtime1.verticalCenter
                gradient: Gradient {
                    GradientStop {
                        position: 0.0
                        color: Theme.rgba(Theme.highlightBackgroundColor, 0.35)
                    }
                    GradientStop {
                        position: 1.0
                        color: Theme.rgba(Theme.highlightBackgroundColor, 0.1)
                    }
                }
            }
            Label {
                id: dishtime1
                text: timeText1
                verticalAlignment: Text.AlignTop
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: largeScreen ? Theme.fontSizeExtraLarge : Theme.fontSizeHuge
                color: timer1running ? Theme.highlightColor : isPaused1 ? Theme.secondaryColor : Theme.secondaryHighlightColor
            }
        }

        Label {
            id: dishname2
            text: dishText2
            horizontalAlignment: Text.AlignHCenter
            width: parent.width
            font.pixelSize: Theme.fontSizeSmall
            color: Theme.primaryColor
            anchors.top: dish1.bottom
            anchors.topMargin: 0
        }
        Item {
            id: dish2
            anchors.topMargin: -Theme.paddingSmall
            anchors.bottomMargin: 0
            anchors.top: dishname2.bottom
            width: parent.width
            height: dishtime2.height
            Rectangle {
                height: dishtime2.height
                width: parent.width * mainapp.progressValue2
                radius: 10
                visible: timer2running || isPaused2
                anchors.verticalCenter: dishtime2.verticalCenter
                gradient: Gradient {
                    GradientStop {
                        position: 0.0
                        color: Theme.rgba(Theme.highlightBackgroundColor, 0.35)
                    }
                    GradientStop {
                        position: 1.0
                        color: Theme.rgba(Theme.highlightBackgroundColor, 0.1)
                    }
                }
            }
            Label {
                id: dishtime2
                text: timeText2
                verticalAlignment: Text.AlignTop
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: largeScreen ? Theme.fontSizeExtraLarge : Theme.fontSizeHuge
                color: timer2running ? Theme.highlightColor : isPaused2 ? Theme.secondaryColor : Theme.secondaryHighlightColor
            }
        }

        Label {
            id: dishname3
            text: dishText3
            horizontalAlignment: Text.AlignHCenter
            width: parent.width
            font.pixelSize: Theme.fontSizeSmall
            color: Theme.primaryColor
            anchors.top: dish2.bottom
            anchors.topMargin: -Theme.paddingSmall
        }
        Item {
            id: dish3
            anchors.topMargin: -Theme.paddingSmall
            anchors.bottomMargin: 0
            anchors.top: dishname3.bottom
            width: parent.width
            height: dishtime3.height
            Rectangle {
                height: dishtime3.height
                width: parent.width * mainapp.progressValue3
                radius: 10
                visible: timer3running || isPaused3
                anchors.verticalCenter: dishtime3.verticalCenter
                gradient: Gradient {
                    GradientStop {
                        position: 0.0
                        color: Theme.rgba(Theme.highlightBackgroundColor, 0.35)
                    }
                    GradientStop {
                        position: 1.0
                        color: Theme.rgba(Theme.highlightBackgroundColor, 0.1)
                    }
                }
            }
            Label {
                id: dishtime3
                text: timeText3
                verticalAlignment: Text.AlignTop
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: largeScreen ? Theme.fontSizeExtraLarge : Theme.fontSizeHuge
                color: timer3running ? Theme.highlightColor : isPaused3 ? Theme.secondaryColor : Theme.secondaryHighlightColor
            }
        }
    }

    CoverActionList {
        id: coverAction

        CoverAction {
            iconSource: timer1running ? (mainapp.isLightTheme ? "../images/icon-cover-stop-rev.png" : "../images/icon-cover-stop.png") : "image://theme/icon-cover-play"
            onTriggered: {
                dishtime1.opacity = 1
                isPaused1 ? mainPage.togglePause1() : mainPage.toggleTimer1()
            }
        }
        CoverAction {
            iconSource: timer2running ? (mainapp.isLightTheme ? "../images/icon-cover-stop-rev.png" : "../images/icon-cover-stop.png") : "image://theme/icon-cover-play"
            onTriggered: {
                dishtime2.opacity = 1
                isPaused2 ? mainPage.togglePause2() : mainPage.toggleTimer2()
            }
        }
        CoverAction {
            iconSource: timer3running ? (mainapp.isLightTheme ? "../images/icon-cover-stop-rev.png" : "../images/icon-cover-stop.png") : "image://theme/icon-cover-play"
            onTriggered: {
                dishtime3.opacity = 1
                isPaused3 ? mainPage.togglePause3() : mainPage.toggleTimer3()
            }
        }
    }
}
