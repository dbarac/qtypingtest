#include <random>
#include <QDebug>
#include <QStringView>
#include <QString>

#include "typingtest.h"

TypingTest::TypingTest(std::vector<QString>& wordDataset,
                       unsigned wordsPerSample, QObject *parent)
    : QObject{parent}, m_wordsPerSample{wordsPerSample},
      m_wordDataset{wordDataset}, m_rng{m_rd()},
      m_randomWordIdx{std::uniform_int_distribution<int>(0, m_wordDataset.size()-1)}
{
    reset();
}

void TypingTest::reset()
{
    m_correctChars = 0;
    m_totalTypedChars = 0;
    m_totalAcceptedChars = 0;
    sampleWordDataset();
    updateTestPrompt(true);
}

void TypingTest::sampleWordDataset()
{
    m_currentWordIdx = 0;
    m_currentWordSample = std::vector<QString>();
    for (unsigned i = 0; i < m_wordsPerSample; i++) {
        QString& randomWord = m_wordDataset[m_randomWordIdx(m_rng)];
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
 * This function should be called every time the user presses a key.
 *
 * - Update character counts (corrent and total).
 * - Update color of the current word depending on text input correctness.
 * - Go to the next word if space was pressed.
 * - Load new word sample if all words in the current sample were typed.
 */
void TypingTest::processKbInput(QString& input, bool backspacePressed, bool spacePressed)
{
    QString& currentTestWord = m_currentWordSample[m_currentWordIdx];
    QString wordColor;
    bool resetTestPrompt = false;

    /* Update character counts only if keypress was not backspace. */
    if (!backspacePressed) {
        if (newCharIsCorrect(currentTestWord, input)) {
            m_correctChars++;
        }
        m_totalTypedChars++;
    }
    if (spacePressed) {
        /* Update accepted character count, set color for typed word
         * and change active word in test prompt. */
        QStringView typedWord(&input[0], input.size()-1);
        if (typedWord == currentTestWord) {
            m_totalAcceptedChars += input.size();
            wordColor = "#fae1c3";
        } else {
            wordColor = "#bb1e10";
        }
        m_testPromptFinished.append(
            QString("<font color='%1'>%2 </font>").arg(wordColor, currentTestWord));
        m_currentWordIdx++;
        if (m_currentWordIdx == m_wordsPerSample) {
            sampleWordDataset();
            resetTestPrompt = true;
        } else {
            QString& nextTestWord = m_currentWordSample[m_currentWordIdx];
            m_testPromptCurrentWord =
                QString("<u>%1</u>").arg(nextTestWord);
            m_testPromptUntyped.remove(0, nextTestWord.size()+1);
        }
    } else {
        /* Set color for each typed letter of current word,
         * depending on correctness. */
        colorCurrentWord(currentTestWord, input);
    }
    updateTestPrompt(resetTestPrompt);
}

void TypingTest::colorCurrentWord(const QString& currentWord, const QString& userInput)
{
    QString color;
    m_testPromptCurrentWord.clear();
    m_testPromptCurrentWord.append("<u>");
    unsigned len = currentWord.size();
    for (unsigned i = 0; i < len; i++) {
        if (i == userInput.size()) {
            /* append untyped part of word (with default color) */
            m_testPromptCurrentWord.append(QStringView(currentWord).right(len-i));
            break;
        }
        if (userInput[i] == currentWord[i]) {
            color = "#fae1c3";
        } else {
            color = "#bb1e10"; /* error */
        }
        m_testPromptCurrentWord.append(
            QString("<font color='%1'>%2</font>").arg(color, currentWord[i]));
    }
    m_testPromptCurrentWord.append("</u>");
}

/*
 * testPrompt contains a sample of words that the user should type.
 * The current word is underlined.
 * Words are colored depending on input correctness.
 */
QString TypingTest::testPrompt() const {
    return m_testPrompt;
}

void TypingTest::updateTestPrompt(bool initialize=false) {
    if (initialize) {
        m_testPromptFinished.clear();
        m_testPromptCurrentWord =
            QString("<u>%1</u>").arg(m_currentWordSample[0]);
        m_testPromptUntyped.clear();
        for (unsigned i = 1; i < m_wordsPerSample; i++) {
            QString& word = m_currentWordSample[i];
            m_testPromptUntyped.append(" ");
            m_testPromptUntyped.append(word);
        }
    }
    m_testPrompt.clear();
    m_testPrompt.append(m_testPromptFinished);
    m_testPrompt.append(m_testPromptCurrentWord);
    m_testPrompt.append(m_testPromptUntyped);
    emit testPromptChanged();
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
