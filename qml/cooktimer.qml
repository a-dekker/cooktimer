import QtQuick 2.2
import Sailfish.Silica 1.0
import harbour.cooktimer.Settings 1.0
import "pages"
import "cover"

ApplicationWindow {
    id: mainapp
    property string timeText1: '00:00:00'
    property string timeText2: '00:00:00'
    property string timeText3: '00:00:00'
    property real progressValue1: 0
    property real progressValue2: 0
    property real progressValue3: 0
    property string dishText1: qsTr('Dish') + ' 1'
    property string dishText2: qsTr('Dish') + ' 2'
    property string dishText3: qsTr('Dish') + ' 3'
    property bool timer1running: false
    property bool timer2running: false
    property bool timer3running: false
    property bool bg_image: true
    property int orientationSetting: (Orientation.Portrait | Orientation.Landscape
                                      | Orientation.LandscapeInverted)
    property bool isLightTheme: {
        if (Theme.colorScheme == Theme.LightOnDark)
            return false
        else
            return true
    }

    initialPage: mainPage

    MainPage {
        id: mainPage
    }

    cover: CoverPage {
        id: cover
    }
    MySettings {
        id: myset
    }

    Component.onCompleted: {
        // This binds the setting for allowed orientations to the property which is used on all sub-pages
        orientationSetting = Qt.binding(function () {
            switch (parseInt(myset.value("orientation"))) {
            case 0:
                return Orientation.Portrait
            case 1:
                return Orientation.Landscape
            case 2:
                return (Orientation.Portrait | Orientation.Landscape
                        | Orientation.LandscapeInverted)
            default:
                return Orientation.Portrait
            }
        })
    }
}
