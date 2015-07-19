/*
  Copyright (C) 2013 Jolla Ltd.
  Contact: Thomas Perl <thomas.perl@jollamobile.com>
  All rights reserved.

  You may use this file under the terms of BSD license as follows:

  Redistribution and use in source and binary forms, with or without
  modification, are permitted provided that the following conditions are met:
    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in the
      documentation and/or other materials provided with the distribution.
    * Neither the name of the Jolla Ltd nor the
      names of its contributors may be used to endorse or promote products
      derived from this software without specific prior written permission.

  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS BE LIABLE FOR
  ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
  ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/
/****************************************************************************************
**
** edited by Nightmare 03/2014
** added third Circle for Seconds
** nightsoft@outlook.com
**
****************************************************************************************/
import QtQuick 2.0
import Sailfish.Silica 1.0

    Dialog {
        id: diaTime
        // anchors.fill: parent
        canAccept: true
        property string infotext: ""
        property int hour: 0
        property int minute: 0
        property int second: 0

        DialogHeader {
            acceptText: qsTr("Save")
            cancelText: qsTr("Cancel")
        }

        onAccepted: {
            hour=pickTime.hour
            second=pickTime.second
            minute=pickTime.minute
            if (nameOfDish.text.trim() === "" ) {
               infotext=diaTime.infotext
            } else {
                infotext=nameOfDish.text.substring(0, 16).trim()
            }
        }

        onRejected: {
            // just reject
        }

        Column {
            id: colSettings
            width: parent.width
            height: parent.height
            spacing: Theme.paddingLarge
            PageHeader {
                title: " "
            }
            Item {
                height: nameOfDish.height - Theme.paddingLarge * 2
                anchors.horizontalCenter: parent.horizontalCenter
                width: nameOfDish.width + Theme.paddingLarge * 2
                Rectangle {
                    anchors.fill: parent
                    opacity: 0.1
                    radius: 8.0
                }
                TextField {
                    id: nameOfDish
                    color: Theme.highlightColor
                    EnterKey.enabled: text.trim().length > 0
                    text: diaTime.infotext
                    anchors.horizontalCenter: parent.horizontalCenter
                    font.pixelSize: Theme.fontSizeLarge
                    EnterKey.onClicked: {
                        nameOfDish.focus = false
                    }
                }
            }
            Label {
                text: ('0' + pickTime.hour).slice(-2) + ":" + ('0' + pickTime.minute).slice(-2) + ":" + ('0' + pickTime.second).slice(-2)
                color: Theme.secondaryColor
                anchors.horizontalCenter: parent.horizontalCenter
                font.pixelSize: Theme.fontSizeLarge
                font.family: Theme.fontSizeSmall
            }
            TimePickerSeconds {
                id: pickTime
                hour: diaTime.hour
                minute: diaTime.minute
                second: diaTime.second
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }

    }
