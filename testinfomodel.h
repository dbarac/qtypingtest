#ifndef TESTINFOMODEL_H
#define TESTINFOMODEL_H

#include <QAbstractTableModel>
#include "testinfo.h"

enum Column {
    WPM = 0,
    Accuracy,
    TestDuration,
    DateTime,
    count /* number of columns */
};

class TestInfoModel : public QAbstractTableModel
{
    Q_OBJECT

public:
    explicit TestInfoModel(QObject *parent = nullptr);

    // Header:
    QVariant headerData(int section, Qt::Orientation orientation, int role = Qt::DisplayRole) const override;

    // Basic functionality:
    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    int columnCount(const QModelIndex &parent) const override;

public slots:
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;
    void appendEntry(unsigned WPM, unsigned accuracy, unsigned testDuration);

private:
    // test attempt info list
    QList<TestInfo> m_testInfoList;
};

#endif // TESTINFOMODEL_H
