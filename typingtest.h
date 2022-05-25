#ifndef TYPINGTEST_H
#define TYPINGTEST_H

#include <QObject>
#include <vector>
#include <string>
#include <random>

class TypingTest : public QObject
{
    Q_OBJECT
public:
    explicit TypingTest(std::vector<QString>& wordDataset, unsigned wordsPerSample, QObject *parent = nullptr);
    void startTest();
    QString updateTestText();
    void processKbInput(char c);
    std::pair<int, int> getTestResult();

private:
    void sampleWordDataset();

    unsigned currentWordIdx = 0;
    unsigned currentCharIdx = 0;
    unsigned m_wordsPerSample = 0;
    unsigned m_correctChars = 0;
    unsigned m_totalTypedChars = 0;
    /* formated string (color) containing the current test word sample. */
    QString m_DisplayStrFinished; /* Completed words in the current sample, so far */
    QString m_DisplayStrCurrent; /* the current word */
    QString m_DisplayStrUntyped;
    QString m_CurrentGuiTestStr;

    bool m_mistakesInCurrentWord;
    std::vector<QString> m_currentWordSample; /* words which are currently on the screen */
    //std::vector<QString> wordsOnScreen;
    std::vector<QString>& m_wordDataset;
    /* for sampling the word dataset */
    std::random_device rd;
    std::mt19937 m_rng;
    std::uniform_int_distribution<int> randomWordIdx;
signals:

};


#endif // TYPINGTEST_H
