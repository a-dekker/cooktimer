#include "insomniac_plugin.h"
#include "insomniac.h"

#include <qqml.h>

void InsomniacPlugin::registerTypes(const char *uri)
{
    // @uri cooktimer.insomniac
    qmlRegisterType<Insomniac>(uri, 1, 0, "Insomniac");
}


