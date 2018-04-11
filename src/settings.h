#ifndef SETTINGS_H
#define SETTINGS_H

#include <QObject>
#include <QSettings>

class Settings : public QObject
{
    Q_OBJECT
    public:
        explicit Settings(QObject *parent = 0);
        Q_INVOKABLE void setValue(const QString & key, const QVariant & value);
        Q_INVOKABLE int valueInt(const QString &key, int defaultValue = 0) const;
        Q_INVOKABLE QString valueString(const QString& key, const QString& defaultValue = QString()) const;
        Q_INVOKABLE QVariant value(const QString &key, const QVariant &defaultValue = QVariant()) const;
        Q_INVOKABLE bool contains(const QString &key) const;
        Q_INVOKABLE void remove(const QString& key);
        Q_INVOKABLE void sync();

signals:

        public slots:
    private:
            QSettings settings_;
};

namespace settingsPublic {

    class Languages : public QObject
    {
        Q_OBJECT

        public:
            Q_ENUMS(eLanguages)
                enum eLanguages {
                    SYSTEM_DEFAULT = 0,
                    EN,    // English
                    SV,    // Swedish
                    FI,    // Finnish
                    DE_DE, // German
                    CS,    // Czech
                    NL,    // Dutch
                    NL_BE, // Flemish
                    ES,    // Spanish
                    FR,    // French
                    IT,    // Italian
                    RU_RU, // Russian
                    EL,    // Greek
                    TR_TR, // Turkish
                    PL,    // Polish
                    DA,    // Danish
                    CA,    // Catalan
                    AR,    // Arabic
                    BR,    // Breton
                    PT_BR, // Portuguese (Brazil)
                    SL_SI, // Slovenian
                    SQ_AL, // Albanian
                    INVALID
                };
    };

} // namespace

#endif // SETTINGS_H
