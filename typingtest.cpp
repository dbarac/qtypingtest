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
    //TODO: set initial gui str
}

void TypingTest::sampleWordDataset()
{
    currentWordIdx = 0;
    m_currentWordSample = std::vector<QString>();
    for (unsigned i = 0; i < m_wordsPerSample; i++) {
        unsigned idx = randomWordIdx(m_rng);
        qDebug() << "'random' idx: "<< idx << "\n";
        QString& randomWord = m_wordDataset[idx];
        m_currentWordSample.push_back(randomWord);
    }

    m_guiTestStr.clear();// = QString();
    m_displayStrCurrent =
        QString("<font color='#847869'><u>%1</u></font>").arg(m_currentWordSample[0]);
    //for (unsigned i = 1; i < m_wordsPerSample; i++) {
    //    QString& word = m_currentWordSample[i];
    //    m_guiTestStr.append(" ");
    //    m_guiTestStr.append(word);
    //}
    m_displayStrUntyped.clear();
    for (unsigned i = currentWordIdx+1; i < m_wordsPerSample; i++) {
        QString& word = m_currentWordSample[i];
        m_displayStrUntyped.append(" ");
        m_displayStrUntyped.append(word);
    }
    m_displayStrFinished.clear();
    qDebug() << m_guiTestStr;
    m_guiTestStr.append(m_displayStrFinished);
    m_guiTestStr.append(m_displayStrCurrent);
    m_guiTestStr.append(m_displayStrUntyped);
    emit guiTestStrChanged();
}

/*
void TypingTest::processKbInput(char c)
{
    QString& currentWord = m_currentWordSample[currentWordIdx];
    // check if correct
    if (currentWord[currentCharIdx] == c) {
        m_correctChars++;
    } else {
        m_mistakesInCurrentWord = true;
    }

    // update idxs
    if (currentCharIdx + 1 == currentWord.size()) {
        currentCharIdx = 0;
        currentWordIdx++;
    } else {
        currentCharIdx++;
    }

    // update display str (emit?)
}
*/

/*
 * Set the color of the current word depending on text input correctness.
 * Go to the next word if space was pressed.
 * Return true if the text input field should be cleared. (new word)
 */
bool TypingTest::processKbInput(QString& input)
{
    QString& currentTestWord = m_currentWordSample[currentWordIdx];
    // check if correct
    QString wordColor;
    bool shouldClearInput = false;
    if (!input.isEmpty() && input.endsWith(" ")) {
        /* set color for typed word, go to next word */
        QStringView typedWord(&input[0], input.size()-1);
        if (typedWord == currentTestWord) {
            m_correctChars += currentTestWord.size();
            wordColor = "#fae1c3";
        } else {
            wordColor = "#bb1e10";
        }
        shouldClearInput = true;
        m_displayStrFinished.append(
            QString("<font color='%1'>%2 </font>").arg(wordColor, currentTestWord));
        currentWordIdx++;
        if (currentWordIdx == m_wordsPerSample) {
            sampleWordDataset();
        } else {
            QString& nextTestWord = m_currentWordSample[currentWordIdx];
            m_displayStrCurrent =
                QString("<u>%1</u>").arg(nextTestWord);
            m_displayStrUntyped.clear();
            for (unsigned i = currentWordIdx+1; i < m_wordsPerSample; i++) {
                QString& word = m_currentWordSample[i];
                m_displayStrUntyped.append(" ");
                m_displayStrUntyped.append(word);
            }
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
    /* update test string for GUI */
    m_guiTestStr.clear();
    m_guiTestStr.append(m_displayStrFinished);
    m_guiTestStr.append(m_displayStrCurrent);
    m_guiTestStr.append(m_displayStrUntyped);
    emit guiTestStrChanged();

    return shouldClearInput;
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
        emit guiTestStrChanged(); // trigger signal of counter change
    }
}
