#include "testresults.h"
#include "testresultsmodel.h"
#include <QDateTime>
#include <QFile>
#include <QDebug>


TestResultsModel::TestResultsModel(QObject *parent)
    : QAbstractTableModel(parent)
{
}

QVariant TestResultsModel::headerData(int section, Qt::Orientation orientation, int role) const
{
    // FIXME: Implement me!
}

int TestResultsModel::rowCount(const QModelIndex &parent) const
{
    // For list models only the root node (an invalid parent) should return the list's size. For all
    // other (valid) parents, rowCount() should return 0 so that it does not become a tree model.
    if (parent.isValid())
        return 0;

    return m_testInfoList.count();
}

int TestResultsModel::columnCount(const QModelIndex &parent) const
{
    // For list models only the root node (an invalid parent) should return the list's size. For all
    // other (valid) parents, rowCount() should return 0 so that it does not become a tree model.
    if (parent.isValid())
        return 0;

    return Column::count;
}

QVariant TestResultsModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid() || role != Qt::DisplayRole)
        return QVariant();

    if (index.row() < 0 || index.row() >= m_testInfoList.count()) {
        return QVariant();
    }

    const TestResults& testResults = m_testInfoList[index.row()];

    switch (index.column()) {
        case Column::WPM:
            return testResults.WPM();
        case Column::Accuracy:
            return testResults.accuracy();
        case Column::TestDuration:
            return testResults.testDuration();
        case Column::DateTime:
            return QDateTime::fromSecsSinceEpoch(
                testResults.timestamp());
    }

    return QVariant();
}

void TestResultsModel::appendEntry(unsigned WPM, unsigned accuracy, unsigned testDuration)
{
    beginInsertRows(QModelIndex(), m_testInfoList.count(), m_testInfoList.count());
    m_testInfoList.append(TestResults(WPM, accuracy, testDuration));
    endInsertRows();
}

void TestResultsModel::loadFromFile(QFile file)
{
    if(file.open(QIODevice::ReadOnly)) {
        QTextStream stream(&file);
        // loop forever macro
        QString line;
        line = stream.readLine(); // skip header
        while (true) {
            line = stream.readLine();
            if(line.isNull()) {
                break;
            }
            if(line.isEmpty()) {
                continue;
            }
            QStringList row = line.split(",");
            unsigned WPM = row[Column::WPM].toUInt();
            unsigned accuracy = row[Column::Accuracy].toUInt();
            unsigned testDuration = row[Column::TestDuration].toUInt();
            qint64 timestamp = row[Column::DateTime].toUInt();
            m_testInfoList.append(TestResults(WPM, accuracy, testDuration, timestamp));
        }
    }
}

void TestResultsModel::saveToFile(QString path)
{
    QFile file(path);
    if(file.open(QIODevice::WriteOnly)) {
        QTextStream out(&file);
        out << "wpm,accuracy,testDuration,timestamp\n";
        for (TestResults& result : m_testInfoList) {
            out << result.WPM() << ","
                << result.accuracy() << ","
                << result.testDuration() << ","
                << result.timestamp() << "\n";
        }
    }
}
