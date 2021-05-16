import QtQuick 2.5
import Sailfish.Silica 1.0

Dialog {
    id: commentPage
    allowedOrientations: mainapp.orientationSetting
    canAccept: commentField.text.match(/\n/g) === null
               || commentField.text.match(/\n/g).length < 4

    property string commenttext: ""

    Column {
        anchors.fill: parent

        DialogHeader {
            acceptText: qsTr("Done")
            cancelText: qsTr("Cancel")
        }

        TextArea {
            id: commentField
            text: commentPage.commenttext
            placeholderText: qsTr("Enter small note here")
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.leftMargin: Theme.paddingLarge
            anchors.rightMargin: Theme.paddingLarge
            wrapMode: Text.Wrap
            focus: true
            color: Theme.primaryColor
            // max of 3 lines
            EnterKey.enabled: text.match(/\n/g) === null || text.match(
                                  /\n/g).length < 3
            EnterKey.onClicked: {
                text = text.substr(0, 100)
            }
        }
    }

    onAccepted: {
        commenttext = commentField.text
    }
}
