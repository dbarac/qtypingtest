#ifndef TYPINGTEST_H
#define TYPINGTEST_H

#include <vector>
#include <string>
#include <random>
#include <QObject>

class TypingTest : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString guiTestStr READ guiTestStr WRITE setGuiTestStr NOTIFY guiTestStrChanged)
public:
    explicit TypingTest(std::vector<QString>& wordDataset, unsigned wordsPerSample, QObject *parent = nullptr);
    void startTest();
    QString updateTestText();
    std::pair<int, int> getTestResult();
    QString guiTestStr() const;
    void setGuiTestStr(QString testStr);

private:
    bool newCharIsCorrect(const QString& currentWord, QString& input);
    unsigned currentWordIdx = 0;
    unsigned currentCharIdx = 0;
    unsigned m_wordsPerSample = 0;
    unsigned m_prevInputLen = 0;
    unsigned m_correctChars = 0;
    unsigned m_totalTypedChars = 0;
    unsigned m_totalAcceptedChars = 0; /* for calculating WPM */
    /* formated string (color) containing the current test word sample. */
    QString m_displayStrFinished; /* Completed words in the current sample, so far */
    QString m_displayStrCurrent; /* the current word */
    QString m_displayStrUntyped;
    QString m_guiTestStr;

    bool m_mistakesInCurrentWord;
    std::vector<QString> m_currentWordSample; /* words which are currently on the screen */
    //std::vector<QString> wordsOnScreen;
    std::vector<QString>& m_wordDataset;
    /* for sampling the word dataset */
    std::random_device rd;
    std::mt19937 m_rng;
    std::uniform_int_distribution<int> randomWordIdx;

public slots:
    void doSomething(const QString& text);
    void sampleWordDataset();
    void processKbInput(QString& input);
    void updateGuiTestStr(bool initialize);
    unsigned calculateWPM(unsigned testTimeSec);
    unsigned calculateAccuracy();

signals:
    void guiTestStrChanged();
};


#endif // TYPINGTEST_H
