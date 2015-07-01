import QtQuick 2.0
import Sailfish.Silica 1.0
import harbour.cooktimer.Settings 1.0
import "../common"
import "Vars.js" as GlobVars

Dialog {
    id: page
    canAccept: true

    property int langNbrToSave: -1

    onAccepted: {
        myset.setValue("backlight", backlight.checked)
        myset.setValue("popup", popup.checked)
        // languagenumber is not index, but enum number!
        if (langNbrToSave !== -1)
            myset.setValue("language", langNbrToSave)
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
            Column {
                width: parent.width
                spacing: 0

                ComboBox {
                    id: language
                    width: page.width
                    label: qsTr("Language:")
                    currentIndex: toCurrentIndex(myset.value("language"))
                    menu: ContextMenu {
                        // make sure it has the order in GlobVars.js
                        MenuItem {
                            text: "System default"
                        } // 0
                        MenuItem {
                            text: "Czech"
                        } // 1
                        MenuItem {
                            text: "Dutch"
                        } // 2
                        MenuItem {
                            text: "English"
                        } // 3
                        MenuItem {
                            text: "Finnish"
                        } // 4
                        MenuItem {
                            text: "French "
                        } // 5
                        MenuItem {
                            text: "German"
                        } // 6
                        MenuItem {
                            text: "Greek"
                        } // 7
                        MenuItem {
                            text: "Russian"
                        } // 8
                        MenuItem {
                            text: "Spanish"
                        } // 9
                        MenuItem {
                            text: "Swedish"
                        } // 10
                        MenuItem {
                            text: "Turkish"
                        } // 11
                    }
                    // The next two converter functions decouple the alphabetical language list
                    // index from the internal settings index, which cannot be changed for legacy reasons
                    function toCurrentIndex(value) {
                        switch (parseInt(value)) {
                        case Languages.SYSTEM_DEFAULT:
                            return GlobVars.system_default
                        case Languages.EN:
                            // English
                            return GlobVars.english
                        case Languages.SV:
                            // Swedish
                            return GlobVars.swedish
                        case Languages.FI:
                            // Finnish
                            return GlobVars.finnish
                        case Languages.DE_DE:
                            // German
                            return GlobVars.german
                        case Languages.CS:
                            // Czech
                            return GlobVars.czech
                        case Languages.NL:
                            // Dutch
                            return GlobVars.dutch
                        case Languages.ES:
                            // Spanish
                            return GlobVars.spanish
                        case Languages.FR:
                            // French
                            return GlobVars.french
                        case Languages.RU_RU:
                            // Russian
                            return GlobVars.russian
                        case Languages.EL:
                            // Greek
                            return GlobVars.greek
                        case Languages.TR_TR:
                            // Turkish
                            return GlobVars.turkish
                        default:
                            return GlobVars.english
                        }
                    }

                    function toSettingsIndex(value) {
                        switch (value) {
                        case GlobVars.system_default:
                            return Languages.SYSTEM_DEFAULT
                        case GlobVars.english:
                            return Languages.EN // English
                        case GlobVars.swedish:
                            return Languages.SV // Swedish
                        case GlobVars.finnish:
                            return Languages.FI // Finnish
                        case GlobVars.german:
                            return Languages.DE_DE // German
                        case GlobVars.czech:
                            return Languages.CS // Czech
                        case GlobVars.dutch:
                            return Languages.NL // Dutch
                        case GlobVars.spanish:
                            return Languages.ES // Spanish
                        case GlobVars.french:
                            return Languages.FR // French
                        case GlobVars.turkish:
                            return Languages.TR_TR // Turkish
                        case GlobVars.russian:
                            return Languages.RU_RU // Russian
                        case GlobVars.greek:
                            return Languages.EL // Greek
                        default:
                            return Languages.EN // English
                        }
                    }

                    onCurrentIndexChanged: {
                        langNbrToSave = toSettingsIndex(language.currentIndex)
                    }
                }

                SilicaLabel {
                    text: qsTr("Change of language will be active after restarting the application.")
                    font.pixelSize: Theme.fontSizeExtraSmall
                    color: Theme.secondaryColor
                }
            }
        }
    }
}
