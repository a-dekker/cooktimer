import QtQuick 2.0
import Sailfish.Silica 1.0
import Launcher 1.0
import Settings 1.0
import org.nemomobile.dbus 1.0
import cooktimer.insomniac 1.0
import QtFeedback 5.0
import "../localdb.js" as DB
import "Vars.js" as GlobVars


// database in /home/nemo/.local/share/cooktimer/cooktimer/QML/OfflineStorage/Databases
Page {
    id: page

    property string myGlobalDish1
    property string myGlobalDuration1
    property string myGlobalDish2
    property string myGlobalDuration2
    property string myGlobalDish3
    property string myGlobalDuration3
    property bool viewable: cover.status === Cover.Active || applicationActive
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
        if (status == PageStatus.Activating) {
            if (GlobVars.myCurrentTimer == "1") {
                // User has navigated back from this page
                myGlobalDish1 = GlobVars.myDish
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
                // do not update if time has been changed
                if (GlobVars.myDuration != " ")
                    myGlobalDuration3 = GlobVars.myDuration
                if (!ticker3.running && !isPaused3) {
                    remainingTime3.text = timer3.text
                    mainapp.timeText3 = remainingTime3.text
                }
            }
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

        property DBusInterface _dbus:  DBusInterface {
                                          id: dbus

                                          destination: "com.nokia.mce"
                                          path: "/com/nokia/mce/request"
                                          iface: "com.nokia.mce.request"

                                          busType: DBusInterface.SystemBus
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
        myGlobalDish2 = GlobVars.myDish
        myGlobalDuration2 = GlobVars.myDuration
        myGlobalDish3 = GlobVars.myDish
        myGlobalDuration3 = GlobVars.myDuration
        DB.initializeDB()
        if (myset.value("backlight") == "true") {
            timer.start()
        }
    }

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

    function alarm(alarmtxt) {
        if ( myset.value("popup") == "true" ) {
            banner.notify(alarmtxt + " " + qsTr("ready"))
        }
        // pageStack.push(Qt.resolvedUrl("AlarmDialogBase.qml"))
        bar.launch("timedclient-qt5 -b'TITLE=button0' -e\"APPLICATION=test;TITLE=" + alarmtxt
                   + "\n" + qsTr("ready") + ";ticker=0;type=countdown;suppressTimeoutSnooze;hideSnoozeButton1\"")
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
            remainingTime2.seconds = 1
            remainingTime2.text = "00:00:00"
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
            remainingTime3.seconds = 1
            remainingTime3.text = "00:00:00"
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

    Image {
        id: coverBgImage
        anchors.fill: parent
        fillMode: Image.PreserveAspectFit
        source: "../images/coverbg.png"
        opacity: 0.1
        horizontalAlignment: Image.AlignHCenter
        verticalAlignment: Image.AlignVCenter
    }

    // To enable PullDownMenu, place our content in a SilicaFlickable
    SilicaFlickable {
        anchors.fill: parent
        // Tell SilicaFlickable the height of its content.
        contentHeight: column.height

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

        Popup {
            id: banner
        }

        // Place our content in a Column.  The PageHeader is always placed at the top
        // of the page, followed by our content.
        Column {
            id: column

            width: page.width
            // set spacing considering the width/height ratio
            spacing: page.height / page.width > 1.6 ? Theme.paddingLarge : Theme.paddingMedium
            PageHeader {
                title: "cooktimer"
            }
            Row {
                /* inner row */
                anchors.horizontalCenter: parent.horizontalCenter
                Button {
                    id: dish1
                    width: (page.width - (Theme.paddingLarge * 2)) / 2.34
                    text: myGlobalDish1 == "Dish" ? qsTr(myGlobalDish1) + " 1" : myGlobalDish1.substring(
                                                        0, 16)
                    onClicked: {
                        GlobVars.myCurrentTimer = 1
                        GlobVars.myDish = dish1.text
                        pageStack.push(Qt.resolvedUrl("DishPage.qml"))
                        mainapp.dishText1 = GlobVars.myDish // = Dish
                    }
                    onPressAndHold: {
                        myGlobalDish1 = GlobVars.myDish = mainapp.dishText1 = qsTr("Dish") + " 1"
                    }
                }
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
                            remainingTime1.text = "00:00:00"
                            mainapp.timeText1 = remainingTime1.text
                        }
                    }
                }
                Button {
                    id: start1
                    width: (page.width - (Theme.paddingLarge * 2)) / 4
                    text: ticker1.running || isPaused1 ? qsTr("Stop") : qsTr("Start")
                    onClicked: {
                        remainingTime1.text = timer1.text
                        mainapp.timeText1 = remainingTime1.text
                        var tt = timer1.text
                        tt = tt.split(":")
                        var sec = tt[0] * 3600 + tt[1] * 60 + tt[2] * 1
                        remainingTime1.seconds = sec
                        GlobVars.myDuration = remainingTime1.text
                        if (remainingTime1.text != "00:00:00"
                                || ticker1.running) {
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
                                remainingTime1.font.underline = false
                            }
                            isPaused1 = false
                        }
                        if (!ticker1.running) {
                            if (insomniac1.running) {
                                insomniac1.stop()
                            }
                        }
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
                        // sound the alarm
                        alarm(dish1.text)
                    }
                }
            }
            Item {
                height: Theme.itemSizeLarge
                anchors.horizontalCenter: parent.horizontalCenter
                width: parent.width - Theme.paddingLarge
                Rectangle {
                    id: rectangle1
                    anchors.fill: parent
                    opacity: 0
                }
                TextField {
                    id: remainingTime1
                    readOnly: true
                    property int seconds
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: Theme.secondaryHighlightColor
                    font.pixelSize: Theme.fontSizeExtraLarge * 1.8
                    text: "00:00:00"
                    onClicked: {
                        if (ticker1.running) {
                            ticker1.stop()
                            isPaused1 = true
                            remainingTime1.color = Theme.secondaryColor
                            remainingTime1.font.bold = false
                            remainingTime1.font.underline = true
                            mainapp.timer1running = !mainapp.timer1running
                        } else if (seconds1 > 0 && isPaused1) {
                            isPaused1 = false
                            GlobVars.myDuration = remainingTime1.text
                            if (remainingTime1.text != "00:00:00"
                                    || ticker1.running) {
                                _lastTick1 = Math.round(Date.now() / 1000)
                                ticker1.running = !ticker1.running
                                mainapp.timer1running = !mainapp.timer1running
                            }
                            ticker1.start()
                            remainingTime1.color = Theme.highlightColor
                            remainingTime1.font.bold = true
                            remainingTime1.font.underline = false
                        }
                    }
                }
            }

            // small grey line
            Rectangle {
                color: "#999999"
                opacity: 0.5
                x: 0
                width: parent.width
                height: 4
                anchors.leftMargin: 20
                anchors.topMargin: 30
            }
            Row {
                /* inner row */
                anchors.horizontalCenter: parent.horizontalCenter
                Button {
                    id: dish2
                    width: (page.width - (Theme.paddingLarge * 2)) / 2.34
                    text: myGlobalDish2 == "Dish" ? qsTr(myGlobalDish2) + " 2" : myGlobalDish2.substring(
                                                        0, 16)
                    onClicked: {
                        GlobVars.myCurrentTimer = 2
                        GlobVars.myDish = dish2.text
                        pageStack.push(Qt.resolvedUrl("DishPage.qml"))
                    }
                    onPressAndHold: {
                        myGlobalDish2 = GlobVars.myDish = mainapp.dishText2 = qsTr("Dish") + " 2"
                    }
                }
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
                            remainingTime2.text = "00:00:00"
                            mainapp.timeText2 = remainingTime2.text
                        }
                    }
                }
                Button {
                    id: start2
                    width: (page.width - (Theme.paddingLarge * 2)) / 4
                    text: ticker2.running || isPaused2 ? qsTr("Stop") : qsTr("Start")
                    onClicked: {
                        remainingTime2.text = timer2.text
                        mainapp.timeText2 = remainingTime2.text
                        var tt = timer2.text
                        tt = tt.split(":")
                        var sec = tt[0] * 3600 + tt[1] * 60 + tt[2] * 1
                        remainingTime2.seconds = sec
                        GlobVars.myDuration = remainingTime2.text
                        if (remainingTime2.text != "00:00:00"
                                || ticker2.running) {
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
                                remainingTime2.font.underline = false
                            }
                            isPaused2 = false
                        }
                        if (!ticker2.running) {
                            if (insomniac2.running) {
                                insomniac2.stop()
                            }
                        }
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
                        // sound the alarm
                        alarm(dish2.text)
                    }
                }
            }
            Item {
                height: Theme.itemSizeLarge
                anchors.horizontalCenter: parent.horizontalCenter
                width: parent.width - Theme.paddingLarge
                Rectangle {
                    anchors.fill: parent
                    opacity: 0.00
                }
                TextField {
                    id: remainingTime2
                    readOnly: true
                    property int seconds
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: Theme.secondaryHighlightColor
                    font.pixelSize: Theme.fontSizeExtraLarge * 1.8
                    text: "00:00:00"
                    onClicked: {
                        if (ticker2.running) {
                            ticker2.stop()
                            isPaused2 = true
                            remainingTime2.color = Theme.secondaryColor
                            remainingTime2.font.bold = false
                            remainingTime2.font.underline = true
                            mainapp.timer2running = !mainapp.timer2running
                        } else if (seconds2 > 0 && isPaused2) {
                            isPaused2 = false
                            GlobVars.myDuration = remainingTime2.text
                            if (remainingTime2.text != "00:00:00"
                                    || ticker2.running) {
                                _lastTick2 = Math.round(Date.now() / 1000)
                                ticker2.running = !ticker2.running
                                mainapp.timer2running = !mainapp.timer2running
                            }
                            ticker2.start()
                            remainingTime2.color = Theme.highlightColor
                            remainingTime2.font.bold = true
                            remainingTime2.font.underline = false
                        }
                    }
                }
            }
            Rectangle {
                color: "#999999"
                opacity: 0.5
                x: 0
                width: parent.width
                height: 4
            }

            Row {
                /* inner row */
                anchors.horizontalCenter: parent.horizontalCenter
                Button {
                    id: dish3
                    width: (page.width - (Theme.paddingLarge * 2)) / 2.34
                    text: myGlobalDish3 == "Dish" ? qsTr(myGlobalDish3) + " 3" : myGlobalDish3.substring(
                                                        0, 16)
                    onClicked: {
                        GlobVars.myCurrentTimer = 3
                        GlobVars.myDish = dish3.text
                        pageStack.push(Qt.resolvedUrl("DishPage.qml"))
                    }
                    onPressAndHold: {
                        myGlobalDish3 = GlobVars.myDish = mainapp.dishText3 = qsTr("Dish") + " 3"
                    }
                }
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
                            remainingTime3.text = "00:00:00"
                            mainapp.timeText3 = remainingTime3.text
                        }
                    }
                }
                Button {
                    id: start3
                    width: (page.width - (Theme.paddingLarge * 2)) / 4
                    text: ticker3.running || isPaused3 ? qsTr("Stop") : qsTr("Start")
                    onClicked: {
                        remainingTime3.text = timer3.text
                        mainapp.timeText3 = remainingTime3.text
                        var tt = timer3.text
                        tt = tt.split(":")
                        var sec = tt[0] * 3600 + tt[1] * 60 + tt[2] * 1
                        remainingTime3.seconds = sec
                        GlobVars.myDuration = remainingTime3.text
                        if (remainingTime3.text != "00:00:00"
                                || ticker3.running) {
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
                                remainingTime3.font.underline = false
                            }
                            isPaused3 = false
                        }
                        if (!ticker3.running) {
                            if (insomniac3.running) {
                                insomniac3.stop()
                            }
                        }
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
                        // sound the alarm
                        alarm(dish3.text)
                    }
                }
            }
            Item {
                height: Theme.itemSizeLarge
                anchors.horizontalCenter: parent.horizontalCenter
                width: parent.width - Theme.paddingLarge
                Rectangle {
                    anchors.fill: parent
                    opacity: 0.00
                }
                TextField {
                    id: remainingTime3
                    readOnly: true
                    property int seconds
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: Theme.secondaryHighlightColor
                    font.pixelSize: Theme.fontSizeExtraLarge * 1.8
                    text: "00:00:00"
                    onClicked: {
                        if (ticker3.running) {
                            ticker3.stop()
                            isPaused3 = true
                            remainingTime3.color = Theme.secondaryColor
                            remainingTime3.font.bold = false
                            remainingTime3.font.underline = true
                            mainapp.timer3running = !mainapp.timer3running
                        } else if (seconds3 > 0 && isPaused3) {
                            isPaused3 = false
                            GlobVars.myDuration = remainingTime3.text
                            if (remainingTime3.text != "00:00:00"
                                    || ticker3.running) {
                                _lastTick3 = Math.round(Date.now() / 1000)
                                ticker3.running = !ticker3.running
                                mainapp.timer3running = !mainapp.timer3running
                            }
                            ticker3.start()
                            remainingTime3.color = Theme.highlightColor
                            remainingTime3.font.bold = true
                            remainingTime3.font.underline = false
                        }
                    }
                }
            }
        }
    }
}
