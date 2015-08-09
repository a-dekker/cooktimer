import QtQuick 2.0
import Sailfish.Silica 1.0
import "../localdb.js" as DB

Dialog {
    id: dishesDialog

    function appendDish(dish, duration) {
        dishlist.model.append({
                                  Dish: dish,
                                  Duration: duration
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
                    width: font.pixelSize * 10
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
                Button {
                    id: cookTime
                    anchors.left: name.right
                    text: Duration
                    width: (dishesDialog.width - (Theme.paddingLarge * 2)) / 3.3
                    onClicked: {
                        var dialog = pageStack.push(Qt.resolvedUrl(
                                                        "TimeDialog.qml"), {
                                                        infotext: Dish,
                                                        hour: cookTime.text.split(
                                                                  ":")[0],
                                                        minute: cookTime.text.split(
                                                                    ":")[1],
                                                        second: cookTime.text.split(
                                                                    ":")[2]
                                                    })
                        dialog.accepted.connect(function () {
                            dishlist.model.setProperty(index, 'Dish',
                                                       dialog.infotext.trim())
                            dishlist.model.setProperty(
                                        index, 'Duration',
                                        (dialog.hour > 9 ? dialog.hour : "0" + dialog.hour) + ":"
                                        + (dialog.minute > 9 ? dialog.minute : "0"
                                                               + dialog.minute) + ":"
                                        + (dialog.second > 9 ? dialog.second : "0" + dialog.second))
                        })
                    }
                }
                IconButton {
                    anchors.left: cookTime.right
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
        if (result === DialogResult.Accepted) {
            // first delete every Dish record
            DB.RemoveAllDishes()
            // Then loop though current list and save
            for (var i = 0; i < dishlist.model.count; ++i) {
                DB.writeDish(dishlist.model.get(i).Dish.trim(),
                             dishlist.model.get(i).Duration)
            }
        }
    }
}
