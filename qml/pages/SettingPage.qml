import QtQuick 2.0
import Sailfish.Silica 1.0
import harbour.cooktimer.Settings 1.0
import "../common"
import "Vars.js" as GlobVars

Dialog {
    id: page
    canAccept: true
    allowedOrientations: mainapp.orientationSetting

    property int langNbrToSave: -1
    property int orientationNbrToSave: -1

    onAccepted: {
        myset.setValue("backlight", backlight.checked)
        myset.setValue("popup", popup.checked)
        // languagenumber is not index, but enum number!
        if (langNbrToSave !== -1)
            myset.setValue("language", langNbrToSave)
        if (orientationNbrToSave !== -1) {
            myset.setValue("orientation", orientationNbrToSave)
            mainapp.orientationSetting = Qt.binding(function () {
                switch (orientationNbrToSave) {
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
            }
            SectionHeader {
                text: qsTr("Settings")
                visible: isPortrait
            }

            TextSwitch {
                id: backlight
                width: parent.width
                text: qsTr("Keep backlight on")
                description: qsTr("Prevent screen from dimming.")
                checked: myset.value("backlight") === "true"
            }
            TextSwitch {
                id: popup
                width: parent.width
                text: qsTr("Show additional banner")
                description: qsTr("Notification banner in upper screen.")
                checked: myset.value("popup") === "true"
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
                        // make sure it has the order in Vars.js
                        MenuItem {
                            text: "System default"
                        } // 0
                        MenuItem {
                            text: "Arabic/العربية"
                        } // 1
                        MenuItem {
                            text: "Breton/Brezhoneg"
                        } // 2
                        MenuItem {
                            text: "Catalan/Català"
                        } // 3
                        MenuItem {
                            text: "Czech/Čeština"
                        } // 4
                        MenuItem {
                            text: "Danish/Danske"
                        } // 5
                        MenuItem {
                            text: "Dutch/Nederlands"
                        } // 6
                        MenuItem {
                            text: "English/English"
                        } // 7
                        MenuItem {
                            text: "Finnish/Suomalainen"
                        } // 8
                        MenuItem {
                            text: "French/Français"
                        } // 9
                        MenuItem {
                            text: "German/Deutsch"
                        } // 10
                        MenuItem {
                            text: "Greek/Ελληνικά"
                        } // 11
                        MenuItem {
                            text: "Polish/Polski"
                        } // 12
                        MenuItem {
                            text: "Portuguese (Brazil)/Português brasileiro"
                        } // 13
                        MenuItem {
                            text: "Russian/Русский"
                        } // 14
                        MenuItem {
                            text: "Spanish/Español"
                        } // 15
                        MenuItem {
                            text: "Swedish/Svensk"
                        } // 16
                        MenuItem {
                            text: "Turkish/Türk"
                        } // 17
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
                        case Languages.CA:
                            // Catalan
                            return GlobVars.catalan
                        case Languages.CS:
                            // Czech
                            return GlobVars.czech
                        case Languages.DA:
                            // Danish
                            return GlobVars.danish
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
                        case Languages.AR:
                            // Arabic
                            return GlobVars.arabic
                        case Languages.PL:
                            // Polish
                            return GlobVars.polish
                        case Languages.BR:
                            // Breton
                            return GlobVars.breton
                        case Languages.PT_BR:
                            // brazilian_portuguese
                            return GlobVars.portuguese_brazil
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
                        case GlobVars.catalan:
                            return Languages.CA // Catalan
                        case GlobVars.czech:
                            return Languages.CS // Czech
                        case GlobVars.dutch:
                            return Languages.NL // Dutch
                        case GlobVars.danish:
                            return Languages.DA // Danish
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
                        case GlobVars.polish:
                            return Languages.PL // Polish
                        case GlobVars.arabic:
                            return Languages.AR // Arabic
                        case GlobVars.breton:
                            return Languages.BR // Breton
                        case GlobVars.portuguese_brazil:
                            return Languages.PT_BR // Portuguese (Brazil)
                        default:
                            return Languages.EN // English
                        }
                    }

                    onCurrentIndexChanged: {
                        langNbrToSave = toSettingsIndex(language.currentIndex)
                    }
                }

                SilicaLabel {
                    text: qsTr(
                              "Change of language will be active after restarting the application.")
                    font.pixelSize: Theme.fontSizeExtraSmall
                    color: Theme.secondaryColor
                }

                ComboBox {
                    id: orientation
                    width: page.width
                    label: qsTr("Orientation:")
                    currentIndex: toCurrentIndex(myset.value("orientation"))
                    menu: ContextMenu {
                        // make sure it has the order in Vars.js
                        MenuItem {
                            text: qsTr("Portrait")
                        } // 0
                        MenuItem {
                            text: qsTr("Landscape")
                        } // 1
                        MenuItem {
                            text: qsTr("Dynamic")
                        } // 2
                    }
                    // The next two converter functions decouple the alphabetical list
                    // index from the internal settings index, which cannot be changed for legacy reasons
                    function toCurrentIndex(value) {
                        switch (parseInt(value)) {
                        case 0:
                            return GlobVars.orientation_portrait
                        case 1:
                            return GlobVars.orientation_landscape
                        case 2:
                            return GlobVars.orientation_dynamic
                        default:
                            return GlobVars.orientation_portrait
                        }
                    }

                    function toSettingsIndex(value) {
                        switch (value) {
                        case GlobVars.orientation_potrait:
                            return 0 // portrait
                        case GlobVars.orientation_landscape:
                            return 1 // landscape
                        case GlobVars.orientation_dynamic:
                            return 2 // dynamic
                        default:
                            return 0 // Portrait
                        }
                    }

                    onCurrentIndexChanged: {
                        orientationNbrToSave = toSettingsIndex(
                                    orientation.currentIndex)
                    }
                }

                SilicaLabel {
                    text: qsTr("Sets the preferred screen orientation.")
                    font.pixelSize: Theme.fontSizeExtraSmall
                    color: Theme.secondaryColor
                }
            }
        }
    }
}
