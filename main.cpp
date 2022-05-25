#include <QGuiApplication>
#include <QQmlApplicationEngine>

#include "typingtest.h"
#include "dataset.h"


int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    TypingTest test(englishTop100, 10, &app);

    QQmlApplicationEngine engine;
    const QUrl url(u"qrc:/qtypetest/main.qml"_qs);
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
