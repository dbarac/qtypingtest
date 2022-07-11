#include <QDateTime>
#include <QString>
#include "testresults.h"


//TestInfo::TestInfo()

TestResults::TestResults(unsigned WPM, unsigned accuracy, unsigned testDuration)
    : m_WPM{WPM}, m_accuracy{accuracy}, m_testDuration{testDuration},
      m_timestamp{QDateTime::currentSecsSinceEpoch()}
{

}

TestResults::TestResults(unsigned WPM, unsigned accuracy, unsigned testDuration, qint64 timestamp)
    : m_WPM{WPM}, m_accuracy{accuracy}, m_testDuration{testDuration},
      m_timestamp{timestamp}
{

}
