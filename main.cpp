#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>

#include "typingtest.h"
#include "dataset.h"


int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    TypingTest *typingTest = new TypingTest(englishTop100, 30, &app);

    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty("typingTest", typingTest);
    typingTest->doSomething("yooo");
    const QUrl url(u"qrc:/qtypetest/main.qml"_qs);
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
