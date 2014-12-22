import QtQuick 2.0
import Sailfish.Silica 1.0
import Settings 1.0

Dialog {
    id: page
    canAccept: true

    onAccepted: {
        myset.setValue("backlight", backlight.checked)
        myset.setValue("popup", popup.checked)
        myset.setValue("progresscircle", progresscircle.checked)
        myset.sync()
    }

    objectName: "SettingPage"
    SilicaFlickable {
        anchors.fill: parent
        contentWidth: parent.width
        contentHeight: col.height

        MySettings {
            id: myset
        }

        clip: true

        ScrollDecorator {
        }

        Column {
            id: col
            spacing: Theme.paddingLarge
            width: parent.width
            DialogHeader {

                acceptText: qsTr("Save")
                cancelText: qsTr("Cancel")
                title: qsTr("Settings")
            }
            Rectangle {
                id: splitter
                color: "#999999"
                x: 20
                width: parent.width - 40
                height: 2
                anchors.leftMargin: 20
                anchors.topMargin: 30
            }

            TextSwitch {
                id: backlight
                width: parent.width
                text: qsTr("Keep backlight on")
                checked: myset.value("backlight") == "true"
            }
            TextSwitch {
                id: popup
                width: parent.width
                text: qsTr("Show additional banner notification")
                checked: myset.value("popup") == "true"
            }
            TextSwitch {
                id: progresscircle
                width: parent.width
                text: qsTr("Show progress circles")
                checked: myset.value("progresscircle") == "true"
            }
      //      TextSwitch {
        //        id: alarm_timing
          //      width: parent.width
          //      text: qsTr("Set alarm in advance")
        //        checked: taskListWindow.taskOpenAppearance
        //        onCheckedChanged: {}
   //         }

            Rectangle {
                color: "#999999"
                x: 20
                width: parent.width - 40
                height: 2
                //anchors.top: projectfulltext.bottom
                anchors.leftMargin: 20
                anchors.topMargin: 30
            }

        }
    }
}
