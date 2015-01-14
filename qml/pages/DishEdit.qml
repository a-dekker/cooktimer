import QtQuick 2.0
import Sailfish.Silica 1.0
import "../localdb.js" as DB

Dialog {
    id: dishesDialog

    function appendDish(dish, duration) {
        dishlist.model.append({
                                  Dish: dish,
                                  Duration_hours: duration.split(":")[0].length
                                  = 2 ? duration.split(
                                            ":")[0] : '0' + duration.split(
                                            ":")[0],
                                        Duration_minutes: duration.split(
                                            ":")[1],
                                        Duration_seconds: duration.split(":")[2]
                              })
    }

    DialogHeader {
        id: header
        acceptText: qsTr("Save")
        cancelText: qsTr("Cancel")

    }
    SilicaListView {
        id: dishlist
        VerticalScrollDecorator {
        }
        model: ListModel {
        }
        anchors.leftMargin: Theme.paddingSmall
        anchors.rightMargin: Theme.paddingSmall
        width: parent.width
        y: header.height + Theme.paddingMedium
        contentHeight: dishlist.count * Theme.itemSizeSmall
        height: parent.height - (header.height + Theme.paddingMedium + addButton.height)

        function loadDishList() {
            DB.readDishesEdit()
        }

        Component.onCompleted: {
            loadDishList()
        }

        delegate: ListItem {
            id: timerItem
            contentHeight: Theme.itemSizeSmall
            ListView.onRemove: animateRemoval(timerItem)

            function remove() {
                remorseAction(qsTr('Deleting'), function () {
                    var idx = index
                    dishlist.model.remove(idx)
                })
            }

            Item {
                TextField {
                    id: name
                    font.pixelSize: Theme.fontSizeSmall
                    placeholderText: qsTr('Dish name')
                    text: Dish
                    width: font.pixelSize * 8
                    RegExpValidator {
                        regExp: /(\w{1,10}\b)/g
                    }
                    onTextChanged: {
                        if (text.length > 0) {
                            dishlist.model.setProperty(index, 'Dish', text)
                        }
                    }
                    EnterKey.enabled: text.trim().length > 0
                }
                TextField {
                    id: hours
                    font.pixelSize: Theme.fontSizeSmall
                    anchors.left: name.right
                    placeholderText: qsTr('Hours')
                    text: Duration_hours
                    width: font.pixelSize * 3
                    horizontalAlignment: TextInput.AlignRight
                    inputMethodHints: Qt.ImhFormattedNumbersOnly
                    validator: RegExpValidator {
                        regExp: /^([0-2][0-9]){1}$/
                    }
                    onTextChanged: {
                        if (text.length > 1) {
                            dishlist.model.setProperty(index,
                                                       'Duration_hours', text)
                        }
                    }
                }
                Label {
                    id: separator
                    anchors.left: hours.right
                    text: ':'
                    width: font.pixelSize * .01
                    color: hours.color //Theme.secondaryHighlightColor;
                }

                TextField {
                    id: minutes
                    font.pixelSize: Theme.fontSizeSmall
                    anchors.left: separator.right
                    placeholderText: qsTr('minutes')
                    text: Duration_minutes
                    width: font.pixelSize * 3
                    horizontalAlignment: TextInput.AlignRight
                    inputMethodHints: Qt.ImhFormattedNumbersOnly
                    validator: RegExpValidator {
                        regExp: /^([0-5][0-9]){1}$/
                    }
                    onTextChanged: {
                        if (text.length > 1) {
                            dishlist.model.setProperty(index,
                                                       'Duration_minutes', text)
                        }
                    }
                }
                Label {
                    id: separator2
                    font.pixelSize: Theme.fontSizeSmall
                    width: font.pixelSize * .01
                    anchors.left: minutes.right
                    text: ':'
                    color: minutes.color //Theme.secondaryHighlightColor;
                }

                TextField {
                    id: seconds
                    anchors.left: separator2.right
                    font.pixelSize: Theme.fontSizeSmall
                    placeholderText: qsTr('seconds')
                    text: Duration_seconds
                    width: font.pixelSize * 3
                    horizontalAlignment: TextInput.AlignRight
                    inputMethodHints: Qt.ImhFormattedNumbersOnly
                    validator: RegExpValidator {
                        regExp: /^([0-5][0-9]){1}$/
                    }
                    onTextChanged: {
                        if (text.length > 1) {
                            dishlist.model.setProperty(index,
                                                       'Duration_seconds', text)
                        }
                    }
                }
                IconButton {
                    anchors.left: seconds.right
                    icon.source: 'image://theme/icon-m-delete'
                    onClicked: remove()
                }
            }
        }
        VerticalScrollDecorator {
            flickable: dishlist
        }
        ViewPlaceholder {
            enabled: dishlist.count === 0
            text: qsTr('No dishes defined. Press the plus button to add one.')
        }
    }
    IconButton {
        id: addButton
        anchors.top: dishlist.bottom
        anchors.right: dishlist.right
        anchors.rightMargin: Theme.paddingMedium
        icon.source: 'image://theme/icon-m-add'
        visible: dishlist.count < 20
        onClicked: {
            appendDish(qsTr('New dish'), '00:00:00')
            dishlist.positionViewAtEnd()
        }
    }

    onDone: {
        console.log('Done:', (result === DialogResult.Accepted))
        if (result == DialogResult.Accepted) {
            // first delete every Dish record
            DB.RemoveAllDishes()
            // Then loop though current list and save
            for (var i = 0; i < dishlist.model.count; ++i) {
                DB.writeDish(dishlist.model.get(i).Dish, dishlist.model.get(
                                 i).Duration_hours + ':' + dishlist.model.get(
                                 i).Duration_minutes + ':' + dishlist.model.get(
                                 i).Duration_seconds)
            }
        }
    }
}
