#include <QGuiApplication>
#include <QApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QFontDatabase>

#include "typingtest.h"
#include "testresultsmodel.h"
#include "resultssortfilterproxymodel.h"
#include "dataset.h"

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);

    TypingTest *typingTest = new TypingTest(englishTop100, 25, &app);

    TestResultsModel *testResults = new TestResultsModel(&app);
    testResults->loadFromFile(QFile("results.csv"));
    ResultsSortFilterProxyModel *proxyModel = new ResultsSortFilterProxyModel(&app);
    proxyModel->setSourceModel(testResults);
    proxyModel->sort(ResultsColumn::DateTime, Qt::DescendingOrder);

    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty("typingTest", typingTest);
    engine.rootContext()->setContextProperty("testResultsModel", testResults);
    engine.rootContext()->setContextProperty("resultsProxyModel", proxyModel);

    const QUrl url(u"qrc:/qtypetest/main.qml"_qs);
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
