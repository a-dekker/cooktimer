import QtQuick 2.1
import Sailfish.Silica 1.0
import "../localdb.js" as DB
import "Vars.js" as GlobVars

Page {
    id: dishPage

    function appendDish(dish, duration) {
        dishlist.model.append({
                                  Dish: dish,
                                  Duration: duration
                              })
    }


    SilicaListView {
        id: dishlist
        width: parent.width
        height: parent.height
        anchors.fill: parent
        anchors.topMargin: 40
        VerticalScrollDecorator {
        }
        model: ListModel {
        }

        function loadDishList() {
            // wipeTaskList()
            DB.readDishes()
        }

        Component.onCompleted: {
            GlobVars.myDuration = " "
            loadDishList()
        }
        delegate: ListItem {
            id: listItem
            //         menu: contextMenu
            contentHeight: Theme.itemSizeMedium // two line delegate
            function setDish() {
                GlobVars.myDish = Dish
                if (GlobVars.myCurrentTimer === 1) {
                   mainapp.dishText1 = Dish
                }
                if (GlobVars.myCurrentTimer === 2) {
                   mainapp.dishText2 = Dish
                }
                if (GlobVars.myCurrentTimer === 3) {
                   mainapp.dishText3 = Dish
                }
                GlobVars.myDuration = Duration
                pageStack.pop()
            }
            Rectangle {
                id: timeRect
                width: parent.width
                height: parent.height
                color: Theme.primaryColor
                opacity: 0.05
                visible: !(index & 1)
            }


            Label {
                id: label
                opacity: (index & 1) ? 0.7 : 0.9
                text: Dish
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                font.pixelSize: Theme.fontSizeMedium
                font.bold: true
                color: listItem.highlighted ? Theme.highlightColor : Theme.primaryColor
            }
            Label {
                anchors.top: label.bottom
                text: Duration
                font.pixelSize: Theme.fontSizeExtraSmall
                color: listItem.highlighted ? Theme.highlightColor : Theme.secondaryColor
                anchors.horizontalCenter: parent.horizontalCenter
            }
            onClicked: {
                setDish()
            }
        }
        ViewPlaceholder {
            enabled: dishlist.count === 0
            text: qsTr("No dishes defined. Choose \"Edit Dishes\" from the pulley menu.")
        }
    }
}
