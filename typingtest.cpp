#include <random>
#include <QDebug>
#include <QStringView>

#include "typingtest.h"

TypingTest::TypingTest(std::vector<QString>& wordDataset,
                       unsigned wordsPerSample, QObject *parent)
    : QObject{parent}, m_wordsPerSample{wordsPerSample},
      m_wordDataset{wordDataset}, m_rng{rd()},
      randomWordIdx{std::uniform_int_distribution<int>(0, m_wordDataset.size()-1)}
{
    sampleWordDataset();
    updateGuiTestStr(true);
}

void TypingTest::sampleWordDataset()
{
    currentWordIdx = 0;
    m_currentWordSample = std::vector<QString>();
    for (unsigned i = 0; i < m_wordsPerSample; i++) {
        QString& randomWord = m_wordDataset[randomWordIdx(m_rng)];
        m_currentWordSample.push_back(randomWord);
    }
}

bool TypingTest::newCharIsCorrect(const QString& currentWord, QString& input)
{
    if (input.size() > currentWord.size()) {
        return input.endsWith(" ");
    }
    return input.back() == currentWord[input.size()-1];
}

/*
 * Update character counts (corrent and total).
 * Set the color of the current word depending on text input correctness.
 * Go to the next word if space was pressed.
 */
void TypingTest::processKbInput(QString& input)
{
    QString& currentTestWord = m_currentWordSample[currentWordIdx];
    QString wordColor;
    bool resetTestStr = false;

    /* Update character counts only if keypress was not backspace. */
    if (input.size() > m_prevInputLen) {
        if (newCharIsCorrect(currentTestWord, input)) {
            m_correctChars++;
        }
        m_totalTypedChars++;
    }
    if (!input.isEmpty() && input.endsWith(" ")) {
        /* set color for typed word, go to next word */
        QStringView typedWord(&input[0], input.size()-1);
        if (typedWord == currentTestWord) {
            m_totalAcceptedChars += input.size();
            wordColor = "#fae1c3";
        } else {
            wordColor = "#bb1e10";
        }
        m_displayStrFinished.append(
            QString("<font color='%1'>%2 </font>").arg(wordColor, currentTestWord));
        currentWordIdx++;
        if (currentWordIdx == m_wordsPerSample) {
            sampleWordDataset();
            resetTestStr = true;
        } else {
            QString& nextTestWord = m_currentWordSample[currentWordIdx];
            m_displayStrCurrent =
                QString("<u>%1</u>").arg(nextTestWord);
            m_displayStrUntyped.remove(0, nextTestWord.size()+1);
        }
    } else {
        /* set color of current word depending on the correctness of input so far */
        colorActiveWord(currentTestWord, input);
    }
    m_prevInputLen = input.size();
    updateGuiTestStr(resetTestStr);
}

void TypingTest::colorActiveWord(const QString& currentWord, const QString& input)
{
    QString color;
    m_displayStrCurrent.clear();
    m_displayStrCurrent.append("<u>");
    unsigned len = currentWord.size();
    for (unsigned i = 0; i < len; i++) {
        if (i == input.size()) {
            /* append untyped part of word (default color) */
            m_displayStrCurrent.append(currentWord.right(len-i));
            break;
        }
        if (input[i] == currentWord[i]) {
            color = "#fae1c3";
        } else {
            color = "#bb1e10"; /* error */
        }
        m_displayStrCurrent.append(
            QString("<font color='%1'>%2</font>").arg(color, currentWord[i]));
    }
    m_displayStrCurrent.append("</u>");
}

void TypingTest::doSomething(const QString& text) {
    qDebug() << "TypingTest doSomething called with" << text;
}

QString TypingTest::guiTestStr() const {
    return m_guiTestStr;
}

void TypingTest::setGuiTestStr(QString testStr) {
    if(m_guiTestStr != testStr) {
        m_guiTestStr = testStr;
        emit guiTestStrChanged();
    }
}

void TypingTest::updateGuiTestStr(bool initialize=false) {
    if (initialize) {
        m_displayStrFinished.clear();
        m_displayStrCurrent =
            QString("<u>%1</u>").arg(m_currentWordSample[0]);
        m_displayStrUntyped.clear();
        for (unsigned i = 1; i < m_wordsPerSample; i++) {
            QString& word = m_currentWordSample[i];
            m_displayStrUntyped.append(" ");
            m_displayStrUntyped.append(word);
        }
    }
    m_guiTestStr.clear();
    m_guiTestStr.append(m_displayStrFinished);
    m_guiTestStr.append(m_displayStrCurrent);
    m_guiTestStr.append(m_displayStrUntyped);
    emit guiTestStrChanged();
}

/*
 * Calculate the number of correctly typed words per minute.
 * Assume average word length is 5 like on most typing websites.
 */
unsigned TypingTest::calculateWPM(unsigned testTimeSec)
{
    float wpm = static_cast<float>(m_totalAcceptedChars) / 5 * 60. / testTimeSec;
    return static_cast<unsigned>(wpm);
}

unsigned TypingTest::calculateAccuracy()
{
    float acc = static_cast<float>(m_correctChars) / m_totalTypedChars;
    return static_cast<unsigned>(acc * 100);
}
