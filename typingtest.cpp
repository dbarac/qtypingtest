#include <random>

#include "typingtest.h"

TypingTest::TypingTest(std::vector<QString>& wordDataset,
                       unsigned wordsPerSample, QObject *parent)
    : QObject{parent}, m_wordsPerSample{wordsPerSample}, m_wordDataset{wordDataset},
      m_rng{rd()}, randomWordIdx{std::uniform_int_distribution<int>(0, wordsPerSample-1)}
{
    sampleWordDataset();
}

void TypingTest::sampleWordDataset()
{
    m_currentWordSample = std::vector<QString>();
    for (unsigned i = 0; i < m_wordsPerSample; i++) {
        QString& randomWord = m_wordDataset[randomWordIdx(m_rng)];
        m_currentWordSample.push_back(randomWord);
    }
}

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
