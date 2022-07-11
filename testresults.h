#ifndef TESTINFO_H
#define TESTINFO_H

#include <QString>

/*
 * Holds information about a finished test attempt.
 */
class TestResults
{
public:
    TestResults(unsigned WPM, unsigned accuracy, unsigned testDuration);
    TestResults(unsigned WPM, unsigned accuracy, unsigned testDuration, qint64 timestamp);
//private:
    unsigned m_WPM;
    unsigned m_accuracy;
    unsigned m_testDuration;
    qint64 m_timestamp;
};

#endif // TESTINFO_H
