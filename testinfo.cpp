#include <QDateTime>
#include <QString>
#include "testinfo.h"


//TestInfo::TestInfo()

TestInfo::TestInfo(unsigned WPM, unsigned accuracy, unsigned testDuration)
    : m_WPM{WPM}, m_accuracy{accuracy}, m_testDuration{testDuration},
      m_timestamp{QDateTime::currentSecsSinceEpoch()}
{

}
