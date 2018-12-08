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

#ifdef QT_QML_DEBUG
#include <QtQuick>
#endif

#include <QGuiApplication>
#include <sailfishapp.h>
#include <QtQml>
#include <qqml.h>
#include <QTimer>
#include <QQuickView>
#include <QProcess>
#include <QTranslator>
#include <QLocale>
#include "osread.h"
#include "settings.h"

int main(int argc, char *argv[])
{
    QProcess appinfo;
    QString appversion;

    // read app version from rpm database on startup
    appinfo.start("/bin/rpm", QStringList() << "-qa" << "--queryformat" << "%{version}-%{RELEASE}" << "cooktimer");
    appinfo.waitForFinished(-1);
    if (appinfo.bytesAvailable() > 0) {
        appversion = appinfo.readAll();
    }

    // SailfishApp::main() will display "qml/template.qml", if you need more
    // control over initialization, you can use:
    //
    //   - SailfishApp::application(int, char *[]) to get the QGuiApplication *
    //   - SailfishApp::createView() to get a new QQuickView * instance
    //   - SailfishApp::pathTo(QString) to get a QUrl to a resource file
    //
    // To display the view, call "show()" (will show fullscreen on device).
    QScopedPointer<QGuiApplication> app(SailfishApp::application(argc, argv));
    QQuickView* view = SailfishApp::createView();
    view->rootContext()->setContextProperty("version", appversion);
    view->engine()->addImportPath(SailfishApp::pathTo("lib/").toLocalFile());
    view->engine()->addImportPath(SailfishApp::pathTo("qml/components/").toLocalFile());
    view->engine()->addImportPath(SailfishApp::pathTo("qml/pages/").toLocalFile());

    // QTranslator *translator = new QTranslator;

    QString locale_appname = "cooktimer-" + QLocale::system().name();
    qDebug() << "Translations:" << SailfishApp::pathTo("translations").toLocalFile() + "/" + locale_appname + ".qm";

    qmlRegisterType<Launcher>("harbour.cooktimer.Launcher", 1 , 0 , "App");
    qmlRegisterType<Settings>("harbour.cooktimer.Settings", 1 , 0 , "MySettings");
    qmlRegisterType<settingsPublic::Languages>("harbour.cooktimer.Settings", 1, 0, "Languages");
    // Check if user has set language explicitly to be used in the app
    QString locale = QLocale::system().name();
    view->rootContext()->setContextProperty("DebugLocale",QVariant(locale));
    // also name of conf folder
    QCoreApplication::setOrganizationName("cooktimer");
    QCoreApplication::setOrganizationDomain("");
    // also name of conf file
    QCoreApplication::setApplicationName("cooktimer");

    QSettings mySets;
    int languageNbr = mySets.value("language","0").toInt();

    QTranslator translator;
    if (settingsPublic::Languages::SYSTEM_DEFAULT != languageNbr) {
        switch (languageNbr) {
        // Czech
        case settingsPublic::Languages::CS:
            translator.load("cooktimer-cs.qm", SailfishApp::pathTo(QString("translations")).toLocalFile());
            break;
        // Dutch
        case settingsPublic::Languages::NL:
            translator.load("cooktimer-nl.qm", SailfishApp::pathTo(QString("translations")).toLocalFile());
            break;
        // Flemish
        case settingsPublic::Languages::NL_BE:
            translator.load("cooktimer-nl_BE.qm", SailfishApp::pathTo(QString("translations")).toLocalFile());
            break;
        // Finnish
        case settingsPublic::Languages::FI:
            translator.load("cooktimer-fi.qm", SailfishApp::pathTo(QString("translations")).toLocalFile());
            break;
        // French
        case settingsPublic::Languages::FR:
            translator.load("cooktimer-fr.qm", SailfishApp::pathTo(QString("translations")).toLocalFile());
            break;
        // German
        case settingsPublic::Languages::DE_DE:
            translator.load("cooktimer-de_DE.qm", SailfishApp::pathTo(QString("translations")).toLocalFile());
            break;
        // Russian
        case settingsPublic::Languages::RU_RU:
            translator.load("cooktimer-ru_RU.qm", SailfishApp::pathTo(QString("translations")).toLocalFile());
            break;
        // Spanish
        case settingsPublic::Languages::ES:
            translator.load("cooktimer-es.qm", SailfishApp::pathTo(QString("translations")).toLocalFile());
            break;
        // Swedish
        case settingsPublic::Languages::SV:
            translator.load("cooktimer-sv.qm", SailfishApp::pathTo(QString("translations")).toLocalFile());
            break;
        // Greek
        case settingsPublic::Languages::EL:
            translator.load("cooktimer-el.qm", SailfishApp::pathTo(QString("translations")).toLocalFile());
            break;
        // Turkish
        case settingsPublic::Languages::TR_TR:
            translator.load("cooktimer-tr_TR.qm", SailfishApp::pathTo(QString("translations")).toLocalFile());
            break;
        // Polish
        case settingsPublic::Languages::PL:
            translator.load("cooktimer-pl.qm", SailfishApp::pathTo(QString("translations")).toLocalFile());
            break;
        // Danish
        case settingsPublic::Languages::DA:
            translator.load("cooktimer-da.qm", SailfishApp::pathTo(QString("translations")).toLocalFile());
            break;
        // Catalan
        case settingsPublic::Languages::CA:
            translator.load("cooktimer-ca.qm", SailfishApp::pathTo(QString("translations")).toLocalFile());
            break;
        // Arabic
        case settingsPublic::Languages::AR:
            translator.load("cooktimer-ar.qm", SailfishApp::pathTo(QString("translations")).toLocalFile());
            break;
        // Breton
        case settingsPublic::Languages::BR:
            translator.load("cooktimer-br.qm", SailfishApp::pathTo(QString("translations")).toLocalFile());
            break;
        // Portuguese (Brazil)
        case settingsPublic::Languages::PT_BR:
            translator.load("cooktimer-pt_BR.qm", SailfishApp::pathTo(QString("translations")).toLocalFile());
            break;
        // Slovenian
        case settingsPublic::Languages::SL_SI:
            translator.load("cooktimer-sl_SI.qm", SailfishApp::pathTo(QString("translations")).toLocalFile());
            break;
        // Albanian
        case settingsPublic::Languages::SQ_AL:
            translator.load("cooktimer-sq_AL.qm", SailfishApp::pathTo(QString("translations")).toLocalFile());
            break;
        // Hungarian
        case settingsPublic::Languages::HU:
            translator.load("cooktimer-hu.qm", SailfishApp::pathTo(QString("translations")).toLocalFile());
            break;
        // Chinese
        case settingsPublic::Languages::ZH_CN:
            translator.load("cooktimer-zh_CN.qm", SailfishApp::pathTo(QString("translations")).toLocalFile());
            break;
            // English
        default:
            translator.load("cooktimer.qm", SailfishApp::pathTo(QString("translations")).toLocalFile());
            break;
        }
        // install translator for specific language
        // otherwise the system language will be set by SailfishApp
        app->installTranslator(&translator);
    }

    view->setSource(SailfishApp::pathTo("qml/cooktimer.qml"));
    view->showFullScreen();
    return app->exec();
}
