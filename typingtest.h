#ifndef TYPINGTEST_H
#define TYPINGTEST_H

#include <vector>
#include <string>
#include <random>
#include <QObject>

class TypingTest : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString testPrompt READ testPrompt NOTIFY testPromptChanged)
public:
    explicit TypingTest(std::vector<QString>& wordDataset, unsigned wordsPerSample, QObject *parent = nullptr);
    QString testPrompt() const;
private:
    bool newCharIsCorrect(const QString& currentWord, QString& input);
    void colorCurrentWord(const QString& currentWord, const QString& input);
    void sampleWordDataset();
    void updateTestPrompt(bool initialize);

    unsigned m_currentWordIdx = 0;
    unsigned m_wordsPerSample = 0;
    unsigned m_prevInputLen = 0;
    unsigned m_correctChars = 0;
    unsigned m_totalTypedChars = 0;
    unsigned m_totalAcceptedChars = 0; /* for calculating WPM */

    /* formated string (color) containing the current test word sample. */
    QString m_testPrompt;
    QString m_testPromptFinished; /* Completed words in the current sample, so far */
    QString m_testPromptCurrentWord;
    QString m_testPromptUntyped;

    std::vector<QString> m_currentWordSample; /* words which are currently on the screen */
    std::vector<QString>& m_wordDataset;
    /* for sampling the word dataset */
    std::random_device m_rd;
    std::mt19937 m_rng;
    std::uniform_int_distribution<int> m_randomWordIdx;

public slots:
    void reset();
    void processKbInput(QString& input);
    unsigned calculateWPM(unsigned testTimeSec);
    unsigned calculateAccuracy();

signals:
    void testPromptChanged();
};


#endif // TYPINGTEST_H
