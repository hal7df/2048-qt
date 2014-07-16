#include <cstdlib>
#include <ctime>

#include <QtGui/QGuiApplication>
#include "qtquick2applicationviewer.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    srand(time(NULL));

    QtQuick2ApplicationViewer viewer;
    viewer.setMainQmlFile(QStringLiteral("qml/2048-qt/main.qml"));
    viewer.showExpanded();

    return app.exec();
}
