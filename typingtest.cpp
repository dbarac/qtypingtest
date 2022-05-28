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

/*
 * Set the color of the current word depending on text input correctness.
 * Go to the next word if space was pressed.
 * Return true if the text input field should be cleared. (new word)
 */
void TypingTest::processKbInput(QString& input)
{
    QString& currentTestWord = m_currentWordSample[currentWordIdx];
    QString wordColor;
    bool resetTestStr = false;

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
        if (!input.isEmpty() && !currentTestWord.startsWith(input)) {
            wordColor = "#bb1e10";
        } else {
            wordColor = "#847869";
        }
        m_displayStrCurrent =
            QString("<font color='%1'><u>%2</u> </font>").arg(wordColor, currentTestWord);
    }
    updateGuiTestStr(resetTestStr);
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
 * Assume average word length to be 5 like on most typing websites.
 */
unsigned TypingTest::calculateWPM(unsigned testTimeSec)
{
    return m_totalAcceptedChars / 5 * 60 / testTimeSec;
}
