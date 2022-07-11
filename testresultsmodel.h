#ifndef TESTINFOMODEL_H
#define TESTINFOMODEL_H

#include <QAbstractTableModel>
#include <QFile>
#include <QList>
#include "testresults.h"


enum Column {
    WPM = 0,
    Accuracy,
    TestDuration,
    DateTime,
    count /* number of columns */
};

class TestResultsModel : public QAbstractTableModel
{
    Q_OBJECT

public:
    explicit TestResultsModel(QObject *parent = nullptr);

    // Header:
    QVariant headerData(int section, Qt::Orientation orientation, int role = Qt::DisplayRole) const override;

    // Basic functionality:
    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    int columnCount(const QModelIndex &parent) const override;

    void loadFromFile(QFile file);

public slots:
    void saveToFile(QString path);
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;
    void appendEntry(unsigned WPM, unsigned accuracy, unsigned testDuration);

private:
    // test attempt info list
    QList<TestResults> m_testInfoList;
};

#endif // TESTINFOMODEL_H