import QtQuick 2.0
import Sailfish.Silica 1.0
import "pages"
import "cover"

ApplicationWindow
{
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
    initialPage: Component { MainPage { } }

    cover: CoverPage {
       id: cover
    }
}
