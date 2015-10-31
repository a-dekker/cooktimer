# NOTICE:
#
# Application name defined in TARGET has a corresponding QML filename.
# If name defined in TARGET is changed, the following needs to be done
# to match new name:
#   - corresponding QML filename must be changed
#   - desktop icon filename must be changed
#   - desktop filename must be changed
#   - icon definition filename in desktop file must be changed
#   - translation filenames have to be changed

# The name of your application
TARGET = cooktimer

DEPLOYMENT_PATH = /usr/share/$${TARGET}

translations.files = translations
translations.path = $${DEPLOYMENT_PATH}


CONFIG += sailfishapp

#SOURCES += src/cooktimer.cpp \
#    src/osread.cpp \
#    src/settings.cpp \

OTHER_FILES += qml/cooktimer.qml \
    qml/cover/CoverPage.qml \
    rpm/cooktimer.changes.in \
    rpm/cooktimer.spec \
    cooktimer.desktop \
    qml/pages/About.qml \
    qml/pages/MainPage.qml \
    qml/pages/DishEdit.qml \
    qml/pages/SettingPage.qml \
    qml/pages/Vars.js \
    qml/pages/DishPage.qml \
    qml/pages/TimePickerSeconds.qml \
    qml/pages/TimeDialog.qml \
    qml/images/coverbg.png \
    qml/images/timepicker.png \
    qml/images/TimePickerSeconds.png \
    qml/images/icon-cover-stop.png \
    qml/localdb.js \
    qml/common/SilicaLabel.qml \

# to disable building translations every time, comment out the
# following CONFIG line
CONFIG += sailfishapp_i18n

INSTALLS += translations

TRANSLATIONS = translations/cooktimer-sv.ts \
               translations/cooktimer-cs.ts \
               translations/cooktimer-nl.ts \
               translations/cooktimer-da.ts \
               translations/cooktimer-ru_RU.ts \
               translations/cooktimer-el.ts \
               translations/cooktimer-fi.ts \
               translations/cooktimer-fr.ts \
               translations/cooktimer-tr_TR.ts \
               translations/cooktimer-de_DE.ts \
               translations/cooktimer-pl.ts \
               translations/cooktimer-ca.ts \
               translations/cooktimer-es.ts
#HEADERS += \
#    src/osread.h \
#    src/settings.h \

TEMPLATE = subdirs
SUBDIRS = src/insomniac src

# only include these files for translation:
lupdate_only {
    SOURCES = qml/*.qml \
              qml/pages/*.qml
}
