#ifndef TESTINFO_H
#define TESTINFO_H

#include <QString>

/*
 * Holds information about a finished test attempt.
 */
class TestInfo
{
public:
    TestInfo(unsigned WPM, unsigned accuracy, unsigned testDuration);
//private:
    unsigned m_WPM;
    unsigned m_accuracy;
    qint64 m_testDuration;
    unsigned m_timestamp;
};

#endif // TESTINFO_H
