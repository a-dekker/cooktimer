TEMPLATE = app

TARGET = cooktimer
CONFIG += sailfishapp

#QT += declarative

SOURCES += cooktimer.cpp \
    osread.cpp \
    settings.cpp \

HEADERS += \
    osread.h \
    settings.h \

CONFIG(release, debug|release) {
    DEFINES += QT_NO_DEBUG_OUTPUT
}

OTHER_FILES +=

isEmpty(VERSION) {
    VERSION = $$system( egrep "^Version:\|^Release:" ../rpm/cooktimer.spec |tr -d "[A-Z][a-z]: " | tr "\\\n" "-" | sed "s/\.$//g"| tr -d "[:space:]")
    message("VERSION is unset, assuming $$VERSION")
}
DEFINES += APP_VERSION=\\\"$$VERSION\\\"
DEFINES += BUILD_YEAR=$$system(date '+%Y')
