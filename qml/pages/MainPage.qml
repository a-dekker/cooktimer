import QtQuick 2.0
import Sailfish.Silica 1.0
import harbour.cooktimer.Launcher 1.0
import harbour.cooktimer.Settings 1.0
import Nemo.DBus 2.0
import Nemo.Notifications 1.0
import cooktimer.insomniac 1.0
import QtFeedback 5.0
import "../localdb.js" as DB
import "Vars.js" as GlobVars


// database in /home/nemo/.local/share/cooktimer/cooktimer/QML/OfflineStorage/Databases
Page {
    id: page
    allowedOrientations: mainapp.orientationSetting

    property bool largeScreen: Screen.sizeCategory === Screen.Large ||
                               Screen.sizeCategory === Screen.ExtraLarge

    property string myGlobalDish1
    property string myGlobalDuration1
    property string myGlobalComment1
    property string myGlobalDish2
    property string myGlobalDuration2
    property string myGlobalComment2
    property string myGlobalDish3
    property string myGlobalDuration3
    property string myGlobalComment3
    property bool viewable: cover.status === Cover.Active
                            || cover.status === Cover.Activating
                            || applicationActive
    property bool isRunning1: ticker1.running || insomniac1.running
    property bool isRunning2: ticker2.running || insomniac2.running
    property bool isRunning3: ticker3.running || insomniac3.running
    property bool isPaused1: false
    property bool isPaused2: false
    property bool isPaused3: false
    property alias seconds1: remainingTime1.seconds
    property alias seconds2: remainingTime2.seconds
    property alias seconds3: remainingTime3.seconds
    property int _lastTick1: 0
    property int _lastTick2: 0
    property int _lastTick3: 0
    // Remaining time in seconds when screen blanks
    property int _remaining1: 0
    property int _remaining2: 0
    property int _remaining3: 0
    property int _totalsecs1: 0
    property int _totalsecs2: 0
    property int _totalsecs3: 0
    ThemeEffect {
        id: buttonBuzz
        effect: ThemeEffect.Press
    }

    onViewableChanged: {
        if (!isRunning1 && !isRunning2 && !isRunning3) {
            return
        }

        if (viewable) {
            // display on
            if (isRunning1) {
                wakeUp1()
            }
            if (isRunning2) {
                wakeUp2()
            }
            if (isRunning3) {
                wakeUp3()
            }
        } else {
            // display off
            if (isRunning1) {
                //console.log("snooze1")
                snooze1()
            }
            if (isRunning2) {
                //console.log("snooze2")
                snooze2()
            }
            if (isRunning3) {
                //console.log("snooze3")
                snooze3()
            }
        }
    }

    onStatusChanged: {
        if (status === PageStatus.Activating) {
            if (GlobVars.myCurrentTimer == "1") {
                // User has navigated back from this page
                myGlobalDish1 = GlobVars.myDish
                myGlobalComment1 = GlobVars.myComment
                // do not update if time has been changed
                if (GlobVars.myDuration != " ")
                    myGlobalDuration1 = GlobVars.myDuration
                if (!ticker1.running && !isPaused1) {
                    remainingTime1.text = timer1.text
                    mainapp.timeText1 = remainingTime1.text
                }
            }
            if (GlobVars.myCurrentTimer == "2") {
                // User has navigated back from this page
                myGlobalDish2 = GlobVars.myDish
                myGlobalComment2 = GlobVars.myComment
                // do not update if time has been changed
                if (GlobVars.myDuration != " ")
                    myGlobalDuration2 = GlobVars.myDuration
                if (!ticker2.running && !isPaused2) {
                    remainingTime2.text = timer2.text
                    mainapp.timeText2 = remainingTime2.text
                }
            }
            if (GlobVars.myCurrentTimer == "3") {
                // User has navigated back from this page
                myGlobalDish3 = GlobVars.myDish
                myGlobalComment3 = GlobVars.myComment
                // do not update if time has been changed
                if (GlobVars.myDuration != " ")
                    myGlobalDuration3 = GlobVars.myDuration
                if (!ticker3.running && !isPaused3) {
                    remainingTime3.text = timer3.text
                    mainapp.timeText3 = remainingTime3.text
                }
            }
            GlobVars.myCurrentTimer = ""
        }
    }

    Timer {
        id: timer

        property alias suspend: timer.running

        interval: 60000
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            dbus.call("req_display_blanking_pause", undefined)
        }

        onRunningChanged: {
            if (!running) {
                dbus.call("req_display_cancel_blanking_pause", undefined)
            }
        }

        property DBusInterface _dbus: DBusInterface {
                                          id: dbus

                                          service: "com.nokia.mce"
                                          path: "/com/nokia/mce/request"
                                          iface: "com.nokia.mce.request"

                                          bus: DBusInterface.SystemBus
                                      }
    }

    Insomniac {
        id: insomniac1
        repeat: false
        timerWindow: 10
        onTimeout: {
            wakeUp1()
        }
        onError: {
            console.warn('Error in wake-up timer1')
        }
    }

    Insomniac {
        id: insomniac2
        repeat: false
        timerWindow: 10
        onTimeout: {
            wakeUp2()
        }
        onError: {
            console.warn('Error in wake-up timer2')
        }
    }
    Insomniac {
        id: insomniac3
        repeat: false
        timerWindow: 10
        onTimeout: {
            wakeUp3()
        }
        onError: {
            console.warn('Error in wake-up timer3')
        }
    }

    MySettings {
        id: myset
    }

    Component.onCompleted: {
        myGlobalDish1 = GlobVars.myDish
        myGlobalDuration1 = GlobVars.myDuration
        myGlobalComment1 = GlobVars.myComment
        myGlobalDish2 = GlobVars.myDish
        myGlobalDuration2 = GlobVars.myDuration
        myGlobalComment2 = GlobVars.myComment
        myGlobalDish3 = GlobVars.myDish
        myGlobalDuration3 = GlobVars.myDuration
        myGlobalComment3 = GlobVars.myComment
        DB.initializeDB()
        if (myset.value("backlight") === "true") {
            timer.start()
        }
    }

    Component.onDestruction: notification.close()

    function timeFromSecs(seconds) {
        var hh = Math.floor(((seconds / 86400) % 1) * 24)
        if (hh < 10) {
            hh = "0" + hh
        }
        var mi = Math.floor(((seconds / 3600) % 1) * 60)
        if (mi < 10) {
            mi = "0" + mi
        }
        var ss = Math.round(((seconds / 60) % 1) * 60)
        if (ss < 10) {
            ss = "0" + ss
        }
        return hh + ":" + mi + ":" + ss
    }

    function toggleTimer1() {
        progressBar1.value = 0
        totalTime1.text = timer1.text
        remainingTime1.text = timer1.text
        mainapp.timeText1 = remainingTime1.text
        var tt = timer1.text
        tt = tt.split(":")
        var sec = _totalsecs1 = tt[0] * 3600 + tt[1] * 60 + tt[2] * 1
        remainingTime1.seconds = sec
        GlobVars.myDuration = remainingTime1.text
        if (remainingTime1.text !== "00:00:00" || ticker1.running) {
            _lastTick1 = Math.round(Date.now() / 1000)
            if (!isPaused1) {
                buttonBuzz.play()
                ticker1.running = !ticker1.running
                mainapp.timer1running = !mainapp.timer1running
            }
            if (ticker1.running) {
                remainingTime1.color = Theme.highlightColor
                remainingTime1.font.bold = true
            } else {
                remainingTime1.color = Theme.secondaryHighlightColor
                remainingTime1.font.bold = false
                remainingTime1.font.italic = false
            }
            isPaused1 = false
        }
        if (!ticker1.running) {
            if (insomniac1.running) {
                insomniac1.stop()
            }
        }
    }

    function toggleTimer2() {
        progressBar2.value = 0
        totalTime2.text = timer2.text
        remainingTime2.text = timer2.text
        mainapp.timeText2 = remainingTime2.text
        var tt = timer2.text
        tt = tt.split(":")
        var sec = _totalsecs2 = tt[0] * 3600 + tt[1] * 60 + tt[2] * 1
        remainingTime2.seconds = sec
        GlobVars.myDuration = remainingTime2.text
        if (remainingTime2.text !== "00:00:00" || ticker2.running) {
            _lastTick2 = Math.round(Date.now() / 1000)
            if (!isPaused2) {
                buttonBuzz.play()
                ticker2.running = !ticker2.running
                mainapp.timer2running = !mainapp.timer2running
            }
            if (ticker2.running) {
                remainingTime2.color = Theme.highlightColor
                remainingTime2.font.bold = true
            } else {
                remainingTime2.color = Theme.secondaryHighlightColor
                remainingTime2.font.bold = false
                remainingTime2.font.italic = false
            }
            isPaused2 = false
        }
        if (!ticker2.running) {
            if (insomniac2.running) {
                insomniac2.stop()
            }
        }
    }

    function toggleTimer3() {
        progressBar3.value = 0
        totalTime3.text = timer3.text
        remainingTime3.text = timer3.text
        mainapp.timeText3 = remainingTime3.text
        var tt = timer3.text
        tt = tt.split(":")
        var sec = _totalsecs3 = tt[0] * 3600 + tt[1] * 60 + tt[2] * 1
        remainingTime3.seconds = sec
        GlobVars.myDuration = remainingTime3.text
        if (remainingTime3.text !== "00:00:00" || ticker3.running) {
            _lastTick3 = Math.round(Date.now() / 1000)
            if (!isPaused3) {
                buttonBuzz.play()
                ticker3.running = !ticker3.running
                mainapp.timer3running = !mainapp.timer3running
            }
            if (ticker3.running) {
                remainingTime3.color = Theme.highlightColor
                remainingTime3.font.bold = true
            } else {
                remainingTime3.color = Theme.secondaryHighlightColor
                remainingTime3.font.bold = false
                remainingTime3.font.italic = false
            }
            isPaused3 = false
        }
        if (!ticker3.running) {
            if (insomniac3.running) {
                insomniac3.stop()
            }
        }
    }

    function banner(category, message) {
        notification.close()
        var notificationCategory
        switch (category) {
        case "INFO":
            notificationCategory = "x-jolla.alarmui.clock"
            break
        }
        notification.category = notificationCategory
        notification.previewBody = "cooktimer"
        notification.previewSummary = message
        notification.publish()
    }

    function snooze1() {
        ticker1.stop()
        _remaining1 = seconds1 - 1
        _lastTick1 = Math.round(Date.now() / 1000)
        // Subtract 10 seconds for timer window
        insomniac1.interval = _remaining1 - 2
        insomniac1.start()
    }

    function snooze2() {
        ticker2.stop()
        _remaining2 = seconds2 - 1
        _lastTick2 = Math.round(Date.now() / 1000)
        // Subtract 10 seconds for timer window
        insomniac2.interval = _remaining2 - 2
        insomniac2.start()
    }

    function snooze3() {
        ticker3.stop()
        _remaining3 = seconds3 - 1
        _lastTick3 = Math.round(Date.now() / 1000)
        // Subtract 10 seconds for timer window
        insomniac3.interval = _remaining3 - 2
        insomniac3.start()
    }

    Notification {
        id: notification
        itemCount: 1
    }

    function alarm(alarmtxt) {
        if (myset.value("popup") === "true") {
            banner("INFO", alarmtxt + " " + qsTr("ready"))
        }
        // pageStack.push(Qt.resolvedUrl("AlarmDialogBase.qml"))
        bar.launch("timedclient-qt5 -b'TITLE=button0' -e\"APPLICATION=nemoalarms;TITLE="
                   + alarmtxt + "\n" + qsTr("ready")
                   + ";ticker=0;timeOfDay=0;triggerTime=1395217218;;type=countdown;suppressTimeoutSnooze;hideSnoozeButton1\"")
    }

    function wakeUp1() {
        //console.log("in wakeup1")
        if (insomniac1.running) {
            insomniac1.stop()
        }

        var now = Math.round(Date.now() / 1000)
        var passed = now - _lastTick1
        _lastTick1 = now

        if (passed >= _remaining1) {
            console.warn('Time1 has passed!', passed - _remaining1, 'seconds')
            remainingTime1.text = "00:00:00"
            progressBar1.value = 0
            mainapp.timeText1 = remainingTime1.text
            mainapp.timer1running = !mainapp.timer1running
            remainingTime1.font.bold = false
            alarm(dish1.text)
        } else {
            _remaining1 = _remaining1 - passed
            seconds1 = _remaining1
            ticker1.start()
        }
    }

    function wakeUp2() {
        //console.log("in wakeup2")
        if (insomniac2.running) {
            insomniac2.stop()
        }

        var now = Math.round(Date.now() / 1000)
        var passed = now - _lastTick2
        _lastTick2 = now

        if (passed >= _remaining2) {
            console.warn('Time2 has passed!', passed - _remaining2, 'seconds')
            // remainingTime2.seconds = 1
            remainingTime2.text = "00:00:00"
            progressBar2.value = 0
            mainapp.timeText2 = remainingTime2.text
            mainapp.timer2running = !mainapp.timer2running
            remainingTime2.font.bold = false
            alarm(dish2.text)
        } else {
            ticker2.start()
            _remaining2 = _remaining2 - passed
            seconds2 = _remaining2
        }
    }

    function wakeUp3() {
        //console.log("in wakeup3")
        if (insomniac3.running) {
            insomniac3.stop()
        }

        var now = Math.round(Date.now() / 1000)
        var passed = now - _lastTick3
        _lastTick3 = now

        if (passed >= _remaining3) {
            console.warn('Time3 has passed!', passed - _remaining3, 'seconds')
            // remainingTime3.seconds = 1
            remainingTime3.text = "00:00:00"
            progressBar3.value = 0
            mainapp.timeText3 = remainingTime3.text
            mainapp.timer3running = !mainapp.timer3running
            remainingTime3.font.bold = false
            alarm(dish3.text)
        } else {
            ticker3.start()
            _remaining3 = _remaining3 - passed
            seconds3 = _remaining3
        }
    }

    function _showDishInfo(dish_name, comment_text) {
        if (infoPanelLoader.status === Loader.Null) {
            infoPanelLoader.source = Qt.resolvedUrl("../common/DishInfoPanel.qml")
            infoPanelLoader.item.parent = page
            infoPanelLoader.item.dish = dish_name
            infoPanelLoader.item.comment = comment_text
        }
        infoPanelLoader.item.showDishInfo()
    }

    Loader {
        id: infoPanelLoader
    }

    Image {
        id: coverBgImage
        anchors.fill: parent
        fillMode: Image.PreserveAspectFit
        source: "../images/coverbg.png"
        opacity: largeScreen ? 0.03 : 0.07
        horizontalAlignment: Image.AlignHCenter
        verticalAlignment: Image.AlignVCenter
    }

    // To enable PullDownMenu, place our content in a SilicaFlickable
    SilicaFlickable {
        anchors.fill: parent
        // Tell SilicaFlickable the height of its content.
        // contentHeight: column.height

        // PullDownMenu and PushUpMenu must be declared in SilicaFlickable, SilicaListView or SilicaGridView
        PullDownMenu {
            MenuItem {
                text: qsTr("About")
                onClicked: pageStack.push(Qt.resolvedUrl("About.qml"))
            }
            MenuItem {
                text: qsTr("Settings")
                onClicked: pageStack.push(Qt.resolvedUrl("SettingPage.qml"))
            }
            MenuItem {
                text: qsTr("Edit dishes")
                onClicked: pageStack.push(Qt.resolvedUrl("DishEdit.qml"))
            }
        }

        App {
            id: bar
        }

        // set spacing considering the width/height ratio
        // spacing: page.height / page.width > 1.6 ? Theme.paddingLarge : Theme.paddingMedium
        PageHeader {
            id: header
            title: "cooktimer"
            visible: isPortrait || largeScreen
        }
        Row {
            /* inner row */
            id: timerRow1
            spacing: largeScreen ? Theme.paddingMedium : Theme.paddingSmall
            anchors.top: isPortrait || largeScreen ? header.bottom : header.top
            anchors.topMargin: isPortrait ? (largeScreen ? Theme.paddingLarge : 0) : Theme.paddingSmall
            anchors.horizontalCenter: parent.horizontalCenter
            height: isPortrait ? (largeScreen ? page.height/12 : Theme.itemSizeMedium) : (largeScreen ? Theme.itemSizeExtraLarge : Theme.paddingLarge * 1.6)

            Button {
                id: dish1
                width: (page.width - (Theme.paddingLarge * 2)) / 2.34
                text: myGlobalDish1 == "Dish" ? qsTr(
                                                    myGlobalDish1) + " 1" : myGlobalDish1.substring(
                                                    0, 16)
                onClicked: {
                    GlobVars.myCurrentTimer = 1
                    GlobVars.myDish = dish1.text
                    GlobVars.myComment = myGlobalComment1
                    pageStack.push(Qt.resolvedUrl("DishPage.qml"))
                }
                onPressAndHold: {
                    myGlobalDish1 = GlobVars.myDish = mainapp.dishText1 = qsTr(
                                "Dish") + " 1"
                    myGlobalComment1 = ""
                }
            }
            Item {
                height: Theme.itemSizeMedium
                width: (page.width - (Theme.paddingLarge * 2)) / 3.3
                Button {
                    id: timer1
                    width: (page.width - (Theme.paddingLarge * 2)) / 3.3
                    text: myGlobalDuration1
                    onClicked: {
                        var dialog = pageStack.push(Qt.resolvedUrl(
                                                        "TimeDialog.qml"), {
                                                        infotext: dish1.text,
                                                        hour: timer1.text.split(
                                                                  ":")[0],
                                                        minute: timer1.text.split(
                                                                    ":")[1],
                                                        second: timer1.text.split(
                                                                    ":")[2]
                                                    })
                        dialog.accepted.connect(function () {
                            GlobVars.myDuration = " "
                            myGlobalDish1 = mainapp.dishText1 = dialog.infotext
                            myGlobalDuration1 = (dialog.hour > 9 ? dialog.hour : "0" + dialog.hour)
                                    + ":" + (dialog.minute > 9 ? dialog.minute : "0"
                                                                 + dialog.minute) + ":"
                                    + (dialog.second > 9 ? dialog.second : "0" + dialog.second)
                            if (!ticker1.running && !isPaused1) {
                                remainingTime1.text = timer1.text
                                mainapp.timeText1 = remainingTime1.text
                            }
                        })
                    }
                    onPressAndHold: {
                        myGlobalDuration1 = "00:00:00"
                        if (!ticker1.running) {
                            progressBar1.value = 0
                            remainingTime1.text = "00:00:00"
                            mainapp.timeText1 = remainingTime1.text
                        }
                    }
                }
            }
            Button {
                id: start1
                width: (page.width - (Theme.paddingLarge * 2)) / 4
                text: ticker1.running || isPaused1 ? qsTr(
                                                         "Stop") : qsTr("Start")
                enabled: timer1.text === "00:00:00" && start1.text !== qsTr(
                             "Stop") ? false : true
                onClicked: {
                    toggleTimer1()
                }
            }
        }
        Timer {
            id: ticker1
            interval: 1000
            running: false
            repeat: true
            onTriggered: {
                var now = Math.round(Date.now() / 1000)
                seconds1 -= now - _lastTick1
                _lastTick1 = now
                remainingTime1.seconds = seconds1
                remainingTime1.text = timeFromSecs(remainingTime1.seconds)
                mainapp.timeText1 = remainingTime1.text
                if (remainingTime1.seconds <= 0) {
                    ticker1.stop()
                    remainingTime1.text = "00:00:00"
                    remainingTime1.font.bold = false
                    mainapp.timeText1 = remainingTime1.text
                    var tt = timer1.text
                    //    running = false
                    mainapp.timer1running = !mainapp.timer1running
                    if (insomniac1.running) {
                        insomniac1.stop()
                    }
                    // make sure the other timers have no highlight color left
                    if (!ticker2.running) {
                        remainingTime2.color = Theme.secondaryHighlightColor
                    }
                    if (!ticker3.running) {
                        remainingTime3.color = Theme.secondaryHighlightColor
                    }
                    progressBar1.value = 0
                    // sound the alarm
                    alarm(dish1.text)
                }
            }
        }
        Item {
            id: counter1
            anchors.top: timerRow1.bottom
            height: isPortrait ? (largeScreen ? page.height/12 : Theme.itemSizeMedium) : Theme.itemSizeSmall
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width - Theme.paddingLarge
            Rectangle {
                anchors.fill: parent
                opacity: 0
            }
            IconButton {
                anchors.right: remainingTime1.left
                anchors.verticalCenter: remainingTime1.top
                anchors.verticalCenterOffset: largeScreen ? Theme.itemSizeSmall : Theme.itemSizeExtraSmall
                y: Theme.paddingLarge
                icon.source: largeScreen ? '../images/icon-l-min.png' : 'image://theme/icon-m-remove'
                onClicked: {
                    var button_minute = parseInt(timer1.text.split(":")[1], 10)
                    if (button_minute > 0) {
                        button_minute = button_minute - 1
                        myGlobalDuration1 = myGlobalDuration1.split(
                                    ":")[0] + ":"
                                + (button_minute > 9 ? button_minute : "0" + button_minute)
                                + ":" + myGlobalDuration1.split(":")[2]
                        buttonBuzz.play()
                        if (!ticker1.running && !isPaused1) {
                            remainingTime1.text = timer1.text
                            mainapp.timeText1 = remainingTime1.text
                        }
                    }
                }
            }
            TextField {
                anchors.bottomMargin: 1
                id: remainingTime1
                readOnly: true
                property int seconds
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: largeScreen ? parent.verticalCenter : parent.bottom
                anchors.verticalCenterOffset: isLandscape ? Theme.paddingSmall : 0
                color: Theme.secondaryHighlightColor
                font.pixelSize: largeScreen ? Theme.fontSizeExtraLarge * 2.5 : Theme.fontSizeExtraLarge * 1.8
                text: "00:00:00"
                onClicked: {
                    if (ticker1.running) {
                        ticker1.stop()
                        isPaused1 = true
                        remainingTime1.color = Theme.secondaryColor
                        remainingTime1.font.bold = false
                        remainingTime1.font.italic = true
                        mainapp.timer1running = !mainapp.timer1running
                    } else if (seconds1 > 0 && isPaused1) {
                        isPaused1 = false
                        GlobVars.myDuration = remainingTime1.text
                        if (remainingTime1.text !== "00:00:00"
                                || ticker1.running) {
                            _lastTick1 = Math.round(Date.now() / 1000)
                            ticker1.running = !ticker1.running
                            mainapp.timer1running = !mainapp.timer1running
                        }
                        ticker1.start()
                        remainingTime1.color = Theme.highlightColor
                        remainingTime1.font.bold = true
                        remainingTime1.font.italic = false
                    }
                }
            }
            IconButton {
                id: plusButton1
                anchors.left: remainingTime1.right
                y: Theme.paddingLarge
                anchors.verticalCenter: remainingTime1.top
                anchors.verticalCenterOffset: largeScreen ? Theme.itemSizeSmall : Theme.itemSizeExtraSmall
                icon.source: largeScreen ? 'image://theme/icon-l-add' : 'image://theme/icon-m-add'
                visible: myGlobalComment1 === "" || isLandscape || largeScreen
                onClicked: {
                    var button_minute = parseInt(timer1.text.split(":")[1], 10)
                    if (button_minute < 59) {
                        button_minute = button_minute + 1
                        myGlobalDuration1 = myGlobalDuration1.split(
                                    ":")[0] + ":"
                                + (button_minute > 9 ? button_minute : "0" + button_minute)
                                + ":" + myGlobalDuration1.split(":")[2]
                        buttonBuzz.play()
                        if (!ticker1.running && !isPaused1) {
                            remainingTime1.text = timer1.text
                            mainapp.timeText1 = remainingTime1.text
                        }
                    }
                }
            }
            IconButton {
                anchors.left: isPortrait ? (largeScreen ? plusButton1.right : remainingTime1.right) : plusButton1.right
                y: Theme.paddingLarge
                icon.source: largeScreen ? 'image://theme/icon-l-document' : 'image://theme/icon-m-note'
                visible: myGlobalComment1 !== ""
                onClicked: {
                    page._showDishInfo(dish1.text, myGlobalComment1)
                }
                onPressAndHold: {
                    if (isPortrait && !largeScreen) {
                        myGlobalComment1 = ""
                    }
                }
            }
        }
        ProgressBar {
            id: progressBar1
            anchors.top: counter1.bottom
            width: parent.width - Theme.paddingLarge * 2
            height: Theme.paddingLarge * 2.5
            anchors.horizontalCenter: parent.horizontalCenter
            maximumValue: 1
            anchors.topMargin: 1
            leftMargin: 0
            rightMargin: 0
            Timer {
                interval: 100
                repeat: true
                onTriggered: progressBar1.value = mainapp.progressValue1
                             = (1 - (remainingTime1.seconds / _totalsecs1) + 0.001)
                running: (Qt.application.active && mainapp.timer1running)
                         || (viewable)
            }
            Label {
                id: totalTime1
                anchors.left: parent.left
                anchors.bottom: parent.bottom
                color: Theme.secondaryColor
                font.pixelSize: Theme.fontSizeExtraSmall
                text: "00:00:00"
            }
            Label {
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                color: Theme.secondaryColor
                font.pixelSize: Theme.fontSizeExtraSmall
                text: "00:00:00"
            }
        }

        Row {
            /* inner row */
            id: timerRow2
            anchors.top: progressBar1.bottom
            anchors.topMargin: isPortrait ? (largeScreen ? Theme.paddingLarge : 0) : 0
            spacing: largeScreen ? Theme.paddingMedium : Theme.paddingSmall
            anchors.horizontalCenter: parent.horizontalCenter
            height: isPortrait ? (largeScreen ? page.height/12 : Theme.itemSizeMedium) : (largeScreen ? page.height / 7 : Theme.paddingLarge * 1.6)
            Button {
                id: dish2
                width: (page.width - (Theme.paddingLarge * 2)) / 2.34
                text: myGlobalDish2 == "Dish" ? qsTr(
                                                    myGlobalDish2) + " 2" : myGlobalDish2.substring(
                                                    0, 16)
                onClicked: {
                    GlobVars.myCurrentTimer = 2
                    GlobVars.myDish = dish2.text
                    GlobVars.myComment = myGlobalComment2
                    pageStack.push(Qt.resolvedUrl("DishPage.qml"))
                }
                onPressAndHold: {
                    myGlobalDish2 = GlobVars.myDish = mainapp.dishText2 = qsTr(
                                "Dish") + " 2"
                    myGlobalComment2 = ""
                }
            }
            Item {
                height: Theme.itemSizeMedium
                width: (page.width - (Theme.paddingLarge * 2)) / 3.3
                Button {
                    id: timer2
                    width: (page.width - (Theme.paddingLarge * 2)) / 3.3
                    text: myGlobalDuration2
                    onClicked: {
                        var dialog = pageStack.push(Qt.resolvedUrl(
                                                        "TimeDialog.qml"), {
                                                        infotext: dish2.text,
                                                        hour: timer2.text.split(
                                                                  ":")[0],
                                                        minute: timer2.text.split(
                                                                    ":")[1],
                                                        second: timer2.text.split(
                                                                    ":")[2]
                                                    })
                        dialog.accepted.connect(function () {
                            GlobVars.myDuration = " "
                            myGlobalDish2 = mainapp.dishText2 = dialog.infotext
                            myGlobalDuration2 = (dialog.hour > 9 ? dialog.hour : "0" + dialog.hour)
                                    + ":" + (dialog.minute > 9 ? dialog.minute : "0"
                                                                 + dialog.minute) + ":"
                                    + (dialog.second > 9 ? dialog.second : "0" + dialog.second)
                            if (!ticker2.running && !isPaused2) {
                                remainingTime2.text = timer2.text
                                mainapp.timeText2 = remainingTime2.text
                            }
                        })
                    }
                    onPressAndHold: {
                        myGlobalDuration2 = "00:00:00"
                        if (!ticker2.running) {
                            progressBar2.value = 0
                            remainingTime2.text = "00:00:00"
                            mainapp.timeText2 = remainingTime2.text
                        }
                    }
                }
            }
            Button {
                id: start2
                width: (page.width - (Theme.paddingLarge * 2)) / 4
                text: ticker2.running || isPaused2 ? qsTr(
                                                         "Stop") : qsTr("Start")
                enabled: timer2.text === "00:00:00" && start2.text !== qsTr(
                             "Stop") ? false : true
                onClicked: {
                    toggleTimer2()
                }
            }
        }
        Timer {
            id: ticker2
            interval: 1000
            running: false
            repeat: true
            onTriggered: {
                var now = Math.round(Date.now() / 1000)
                seconds2 -= now - _lastTick2
                _lastTick2 = now
                remainingTime2.seconds = seconds2
                remainingTime2.text = timeFromSecs(remainingTime2.seconds)
                mainapp.timeText2 = remainingTime2.text
                if (remainingTime2.seconds <= 0) {
                    ticker2.stop()
                    remainingTime2.text = "00:00:00"
                    remainingTime2.font.bold = false
                    mainapp.timeText2 = remainingTime2.text
                    //    running = false
                    mainapp.timer2running = !mainapp.timer2running
                    if (insomniac2.running) {
                        insomniac2.stop()
                    }
                    // make sure the other timers have no highlight color left
                    if (!ticker1.running) {
                        remainingTime1.color = Theme.secondaryHighlightColor
                    }
                    if (!ticker3.running) {
                        remainingTime3.color = Theme.secondaryHighlightColor
                    }
                    progressBar2.value = 0
                    // sound the alarm
                    alarm(dish2.text)
                }
            }
        }
        Item {
            id: counter2
            anchors.top: timerRow2.bottom
            height: isPortrait ? (largeScreen ? page.height/12 : Theme.itemSizeMedium) : Theme.itemSizeSmall
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width - Theme.paddingLarge
            Rectangle {
                anchors.fill: parent
                opacity: 0
            }
            IconButton {
                anchors.right: remainingTime2.left
                anchors.verticalCenter: remainingTime2.top
                anchors.verticalCenterOffset: largeScreen ? Theme.itemSizeSmall : Theme.itemSizeExtraSmall
                y: Theme.paddingLarge
                icon.source: largeScreen ? '../images/icon-l-min.png' : 'image://theme/icon-m-remove'
                onClicked: {
                    var button_minute = parseInt(timer2.text.split(":")[1], 10)
                    if (button_minute > 0) {
                        button_minute = button_minute - 1
                        myGlobalDuration2 = myGlobalDuration2.split(
                                    ":")[0] + ":"
                                + (button_minute > 9 ? button_minute : "0" + button_minute)
                                + ":" + myGlobalDuration2.split(":")[2]
                        buttonBuzz.play()
                        if (!ticker2.running && !isPaused2) {
                            remainingTime2.text = timer2.text
                            mainapp.timeText2 = remainingTime2.text
                        }
                    }
                }
            }
            TextField {
                id: remainingTime2
                readOnly: true
                property int seconds
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: largeScreen ? parent.verticalCenter : parent.bottom
                anchors.verticalCenterOffset: isLandscape ? Theme.paddingSmall : 0
                color: Theme.secondaryHighlightColor
                font.pixelSize: largeScreen ? Theme.fontSizeExtraLarge * 2.5 : Theme.fontSizeExtraLarge * 1.8
                text: "00:00:00"
                onClicked: {
                    if (ticker2.running) {
                        ticker2.stop()
                        isPaused2 = true
                        remainingTime2.color = Theme.secondaryColor
                        remainingTime2.font.bold = false
                        remainingTime2.font.italic = true
                        mainapp.timer2running = !mainapp.timer2running
                    } else if (seconds2 > 0 && isPaused2) {
                        isPaused2 = false
                        GlobVars.myDuration = remainingTime2.text
                        if (remainingTime2.text !== "00:00:00"
                                || ticker2.running) {
                            _lastTick2 = Math.round(Date.now() / 1000)
                            ticker2.running = !ticker2.running
                            mainapp.timer2running = !mainapp.timer2running
                        }
                        ticker2.start()
                        remainingTime2.color = Theme.highlightColor
                        remainingTime2.font.bold = true
                        remainingTime2.font.italic = false
                    }
                }
            }
            IconButton {
                id: plusButton2
                anchors.left: remainingTime2.right
                y: Theme.paddingLarge
                anchors.verticalCenter: remainingTime2.top
                anchors.verticalCenterOffset: largeScreen ? Theme.itemSizeSmall : Theme.itemSizeExtraSmall
                icon.source: largeScreen ? 'image://theme/icon-l-add' : 'image://theme/icon-m-add'
                visible: myGlobalComment2 === "" || isLandscape || largeScreen
                onClicked: {
                    var button_minute = parseInt(timer2.text.split(":")[1], 10)
                    if (button_minute < 59) {
                        button_minute = button_minute + 1
                        myGlobalDuration2 = myGlobalDuration2.split(
                                    ":")[0] + ":"
                                + (button_minute > 9 ? button_minute : "0" + button_minute)
                                + ":" + myGlobalDuration2.split(":")[2]
                        buttonBuzz.play()
                        if (!ticker2.running && !isPaused2) {
                            remainingTime2.text = timer2.text
                            mainapp.timeText2 = remainingTime2.text
                        }
                    }
                }
            }
            IconButton {
                anchors.left: isPortrait ? (largeScreen ? plusButton2.right : remainingTime2.right) : plusButton2.right
                y: Theme.paddingLarge
                icon.source: largeScreen ? 'image://theme/icon-l-document' : 'image://theme/icon-m-note'
                visible: myGlobalComment2 !== ""
                onClicked: {
                    page._showDishInfo(dish2.text, myGlobalComment2)
                }
                onPressAndHold: {
                    if (isPortrait && !largeScreen) {
                        myGlobalComment2 = ""
                    }
                }
            }
        }
        ProgressBar {
            id: progressBar2
            anchors.top: counter2.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width - 2 * Theme.paddingLarge
            height: Theme.paddingLarge * 2.5
            maximumValue: 1
            anchors.topMargin: 1
            leftMargin: 0
            rightMargin: 0
            Timer {
                interval: 100
                repeat: true
                onTriggered: progressBar2.value = mainapp.progressValue2
                             = (1 - (remainingTime2.seconds / _totalsecs2) + 0.001)
                running: (Qt.application.active && mainapp.timer2running)
                         || (viewable)
            }
            Label {
                id: totalTime2
                anchors.left: parent.left
                anchors.bottom: parent.bottom
                color: Theme.secondaryColor
                font.pixelSize: Theme.fontSizeExtraSmall
                text: "00:00:00"
            }
            Label {
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                color: Theme.secondaryColor
                font.pixelSize: Theme.fontSizeExtraSmall
                text: "00:00:00"
            }
        }
        Row {
            /* inner row */
            id: timerRow3
            anchors.top: progressBar2.bottom
            anchors.topMargin: isPortrait ? (largeScreen ? Theme.paddingLarge : 0) : 0
            spacing: largeScreen ? Theme.paddingMedium : Theme.paddingSmall
            anchors.horizontalCenter: parent.horizontalCenter
            height: isPortrait ? (largeScreen ? page.height/12 : Theme.itemSizeMedium) : (largeScreen ? page.height / 7 : Theme.paddingLarge * 1.6)
            Button {
                id: dish3
                width: (page.width - (Theme.paddingLarge * 2)) / 2.34
                text: myGlobalDish3 == "Dish" ? qsTr(
                                                    myGlobalDish3) + " 3" : myGlobalDish3.substring(
                                                    0, 16)
                onClicked: {
                    GlobVars.myCurrentTimer = 3
                    GlobVars.myDish = dish3.text
                    GlobVars.myComment = myGlobalComment3
                    pageStack.push(Qt.resolvedUrl("DishPage.qml"))
                }
                onPressAndHold: {
                    myGlobalDish3 = GlobVars.myDish = mainapp.dishText3 = qsTr(
                                "Dish") + " 3"
                    myGlobalComment3 = ""
                }
            }
            Item {
                height: Theme.itemSizeMedium
                width: (page.width - (Theme.paddingLarge * 2)) / 3.3
                Button {
                    id: timer3
                    width: (page.width - (Theme.paddingLarge * 2)) / 3.3
                    text: myGlobalDuration3
                    onClicked: {
                        var dialog = pageStack.push(Qt.resolvedUrl(
                                                        "TimeDialog.qml"), {
                                                        infotext: dish3.text,
                                                        hour: timer3.text.split(
                                                                  ":")[0],
                                                        minute: timer3.text.split(
                                                                    ":")[1],
                                                        second: timer3.text.split(
                                                                    ":")[2]
                                                    })
                        dialog.accepted.connect(function () {
                            GlobVars.myDuration = " "
                            myGlobalDish3 = mainapp.dishText3 = dialog.infotext
                            myGlobalDuration3 = (dialog.hour > 9 ? dialog.hour : "0" + dialog.hour)
                                    + ":" + (dialog.minute > 9 ? dialog.minute : "0"
                                                                 + dialog.minute) + ":"
                                    + (dialog.second > 9 ? dialog.second : "0" + dialog.second)
                            if (!ticker3.running && !isPaused3) {
                                remainingTime3.text = timer3.text
                                mainapp.timeText3 = remainingTime3.text
                            }
                        })
                    }
                    onPressAndHold: {
                        myGlobalDuration3 = "00:00:00"
                        if (!ticker3.running) {
                            progressBar3.value = 0
                            remainingTime3.text = "00:00:00"
                            mainapp.timeText3 = remainingTime3.text
                        }
                    }
                }
            }
            Button {
                id: start3
                width: (page.width - (Theme.paddingLarge * 2)) / 4
                text: ticker3.running || isPaused3 ? qsTr(
                                                         "Stop") : qsTr("Start")
                enabled: timer3.text === "00:00:00" && start3.text !== qsTr(
                             "Stop") ? false : true
                onClicked: {
                    toggleTimer3()
                }
            }
        }
        Timer {
            id: ticker3
            interval: 1000
            running: false
            repeat: true
            onTriggered: {
                var now = Math.round(Date.now() / 1000)
                seconds3 -= now - _lastTick3
                _lastTick3 = now
                remainingTime3.seconds = seconds3
                remainingTime3.text = timeFromSecs(remainingTime3.seconds)
                mainapp.timeText3 = remainingTime3.text
                if (remainingTime3.seconds <= 0) {
                    ticker3.stop()
                    remainingTime3.text = "00:00:00"
                    remainingTime3.font.bold = false
                    mainapp.timeText3 = remainingTime3.text
                    //    running = false
                    mainapp.timer3running = !mainapp.timer3running
                    if (insomniac3.running) {
                        insomniac3.stop()
                    }
                    // make sure the other timers have no highlight color left
                    if (!ticker1.running) {
                        remainingTime1.color = Theme.secondaryHighlightColor
                    }
                    if (!ticker2.running) {
                        remainingTime2.color = Theme.secondaryHighlightColor
                    }
                    progressBar3.value = 0
                    // sound the alarm
                    alarm(dish3.text)
                }
            }
        }
        Item {
            id: counter3
            anchors.top: timerRow3.bottom
            height: isPortrait ? (largeScreen ? page.height/12 : Theme.itemSizeMedium) : Theme.itemSizeSmall
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width - Theme.paddingLarge
            Rectangle {
                anchors.fill: parent
                opacity: 0
            }
            IconButton {
                anchors.right: remainingTime3.left
                anchors.verticalCenter: remainingTime3.top
                anchors.verticalCenterOffset: largeScreen ? Theme.itemSizeSmall : Theme.itemSizeExtraSmall
                y: Theme.paddingLarge
                icon.source: largeScreen ? '../images/icon-l-min.png' : 'image://theme/icon-m-remove'
                onClicked: {
                    var button_minute = parseInt(timer3.text.split(":")[1], 10)
                    if (button_minute > 0) {
                        button_minute = button_minute - 1
                        myGlobalDuration3 = myGlobalDuration3.split(
                                    ":")[0] + ":"
                                + (button_minute > 9 ? button_minute : "0" + button_minute)
                                + ":" + myGlobalDuration3.split(":")[2]
                        buttonBuzz.play()
                        if (!ticker3.running && !isPaused3) {
                            remainingTime3.text = timer3.text
                            mainapp.timeText3 = remainingTime3.text
                        }
                    }
                }
            }
            TextField {
                id: remainingTime3
                readOnly: true
                property int seconds
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: largeScreen ? parent.verticalCenter : parent.bottom
                anchors.verticalCenterOffset: isLandscape ? Theme.paddingSmall : 0
                color: Theme.secondaryHighlightColor
                font.pixelSize: largeScreen ? Theme.fontSizeExtraLarge * 2.5 : Theme.fontSizeExtraLarge * 1.8
                text: "00:00:00"
                onClicked: {
                    if (ticker3.running) {
                        ticker3.stop()
                        isPaused3 = true
                        remainingTime3.color = Theme.secondaryColor
                        remainingTime3.font.bold = false
                        remainingTime3.font.italic = true
                        mainapp.timer3running = !mainapp.timer3running
                    } else if (seconds3 > 0 && isPaused3) {
                        isPaused3 = false
                        GlobVars.myDuration = remainingTime3.text
                        if (remainingTime3.text !== "00:00:00"
                                || ticker3.running) {
                            _lastTick3 = Math.round(Date.now() / 1000)
                            ticker3.running = !ticker3.running
                            mainapp.timer3running = !mainapp.timer3running
                        }
                        ticker3.start()
                        remainingTime3.color = Theme.highlightColor
                        remainingTime3.font.bold = true
                        remainingTime3.font.italic = false
                    }
                }
            }
            IconButton {
                id: plusButton3
                anchors.left: remainingTime3.right
                y: Theme.paddingLarge
                anchors.verticalCenter: remainingTime3.top
                anchors.verticalCenterOffset: largeScreen ? Theme.itemSizeSmall : Theme.itemSizeExtraSmall
                icon.source: largeScreen ? 'image://theme/icon-l-add' : 'image://theme/icon-m-add'
                visible: myGlobalComment3 === "" || isLandscape || largeScreen
                onClicked: {
                    var button_minute = parseInt(timer3.text.split(":")[1], 10)
                    if (button_minute < 59) {
                        button_minute = button_minute + 1
                        myGlobalDuration3 = myGlobalDuration3.split(
                                    ":")[0] + ":"
                                + (button_minute > 9 ? button_minute : "0" + button_minute)
                                + ":" + myGlobalDuration3.split(":")[2]
                        buttonBuzz.play()
                        if (!ticker3.running && !isPaused3) {
                            remainingTime3.text = timer3.text
                            mainapp.timeText3 = remainingTime3.text
                        }
                    }
                }
            }
            IconButton {
                anchors.left: isPortrait ? (largeScreen ? plusButton3.right : remainingTime3.right) : plusButton3.right
                y: Theme.paddingLarge
                icon.source: largeScreen ? 'image://theme/icon-l-document' : 'image://theme/icon-m-note'
                visible: myGlobalComment3 !== ""
                onClicked: {
                    page._showDishInfo(dish3.text, myGlobalComment3)
                }
                onPressAndHold: {
                    if (isPortrait && !largeScreen) {
                        myGlobalComment3 = ""
                    }
                }
            }
        }
        ProgressBar {
            id: progressBar3
            anchors.top: counter3.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width - 2 * Theme.paddingLarge
            height: Theme.paddingLarge * 2.5
            maximumValue: 1
            anchors.topMargin: 1
            anchors.bottomMargin: 1
            leftMargin: 0
            rightMargin: 0
            Timer {
                interval: 100
                repeat: true
                onTriggered: progressBar3.value = mainapp.progressValue3
                             = (1 - (remainingTime3.seconds / _totalsecs3) + 0.001)
                running: (Qt.application.active && mainapp.timer3running)
                         || (viewable)
            }
            Label {
                id: totalTime3
                anchors.left: parent.left
                anchors.bottom: parent.bottom
                color: Theme.secondaryColor
                font.pixelSize: Theme.fontSizeExtraSmall
                text: "00:00:00"
            }
            Label {
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                color: Theme.secondaryColor
                font.pixelSize: Theme.fontSizeExtraSmall
                text: "00:00:00"
            }
        }
    }
}
