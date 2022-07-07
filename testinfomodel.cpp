#include "testinfo.h"
#include "testinfomodel.h"
#include <QDateTime>
#include <QDebug>


TestInfoModel::TestInfoModel(QObject *parent)
    : QAbstractTableModel(parent)
{
}

QVariant TestInfoModel::headerData(int section, Qt::Orientation orientation, int role) const
{
    // FIXME: Implement me!
}

int TestInfoModel::rowCount(const QModelIndex &parent) const
{
    // For list models only the root node (an invalid parent) should return the list's size. For all
    // other (valid) parents, rowCount() should return 0 so that it does not become a tree model.
    if (parent.isValid())
        return 0;

    // FIXME: Implement me!
    return m_testInfoList.count();
}

int TestInfoModel::columnCount(const QModelIndex &parent) const
{
    // For list models only the root node (an invalid parent) should return the list's size. For all
    // other (valid) parents, rowCount() should return 0 so that it does not become a tree model.
    if (parent.isValid())
        return 0;

    // FIXME: Implement me!
    return Column::count;
}

QVariant TestInfoModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid() || role != Qt::DisplayRole)
        return QVariant();

    // FIXME: Implement me!
    // (role != Qt::DisplayRole ||
    if (index.row() < 0 || index.row() >= m_testInfoList.count()) {
        return QVariant();
    }

    const TestInfo& testResults = m_testInfoList[index.row()];

    switch (index.column()) {
        case Column::WPM:
            return testResults.m_WPM;
        case Column::Accuracy:
            return testResults.m_accuracy;
        case Column::TestDuration:
            return testResults.m_testDuration;
        case Column::DateTime:
            return QDateTime::fromSecsSinceEpoch(
                testResults.m_timestamp).toString("dd/MM/yyyy hh:mm:ss");
    }

    //QString resultsStr =
    //    QString("%1 %2").arg(QString::number(testResults.m_WPM), QString::number(testResults.m_accuracy));
    //qDebug() << resultsStr << " " << testResults.m_accuracy << "\n";
    //return resultsStr;
    return QVariant();
}

void TestInfoModel::appendEntry(unsigned WPM, unsigned accuracy, unsigned testDuration)
{
    beginInsertRows(QModelIndex(), m_testInfoList.count(), m_testInfoList.count());
    m_testInfoList.append(TestInfo(WPM, accuracy, testDuration));
    endInsertRows();
}
