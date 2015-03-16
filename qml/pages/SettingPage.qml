import QtQuick 2.0
import Sailfish.Silica 1.0
import Settings 1.0

Dialog {
    id: page
    canAccept: true

    onAccepted: {
        myset.setValue("backlight", backlight.checked)
        myset.setValue("popup", popup.checked)
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
      //          title: qsTr("Settings")
            }
            SectionHeader {
                text: qsTr("Settings")
            }

            TextSwitch {
                id: backlight
                width: parent.width
                text: qsTr("Keep backlight on")
                description: qsTr("Prevent screen from dimming.")
                checked: myset.value("backlight") == "true"
            }
            TextSwitch {
                id: popup
                width: parent.width
                text: qsTr("Show additional banner")
                description: qsTr("Notification banner in upper screen.")
                checked: myset.value("popup") == "true"
            }
      //      TextSwitch {
        //        id: alarm_timing
          //      width: parent.width
          //      text: qsTr("Set alarm in advance")
        //        checked: taskListWindow.taskOpenAppearance
        //        onCheckedChanged: {}
   //         }

        }
    }
}
