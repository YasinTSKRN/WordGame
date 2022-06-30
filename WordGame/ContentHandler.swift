//
//  ContentHandler.swift
//  WordGame
//
//  Created by Yasin Taşkıran on 28.06.2022.
//

import Foundation
import SwiftUI

enum GameState {
    case initialize
    case onProgress
    case ended
}

class ContentHandler: ObservableObject {

    var words: [WordSet] = []

    private var usedQuestions: [Int] = []
    private var currentSet: WordSet?
    private var timer: Timer?

    @Published var gameState: GameState = .initialize
    @Published var currentSpanishWord = ""
    @Published var currentEnglishWord = ""
    @Published var currentCorrectAnswers = 0
    @Published var currentWrongAnswers = 0

    init() {
        decodeWords()
    }

    init(words: [WordSet]) {
        self.words = words
    }

    private func decodeWords() {
        let url = Bundle.main.url(forResource: "words", withExtension: "json")
        let jsonData = try! Data(contentsOf: url!)
        self.words = try! JSONDecoder().decode([WordSet].self, from: jsonData)
    }

    func startGame() {
        self.gameState = .onProgress
        self.currentCorrectAnswers = 0
        self.currentWrongAnswers = 0
        self.createQuestion()
    }

    private func createQuestion() {
        currentSet = nil
        var alternateSet: WordSet?
        if let index = getRandomElementIndex(exceptionIndexes: usedQuestions) {
            currentSet = words[index]
            usedQuestions.append(index)
            if Int.random(in: 0..<4) != 0 {
                if let alternateIndex = getRandomElementIndex(exceptionIndexes: [index]) {
                    alternateSet = words[alternateIndex]
                }
            }
        }
        if currentSet == nil {
            self.endGame()
        }
        if let currentSet = currentSet {
            self.currentEnglishWord = currentSet.text_eng
            self.currentSpanishWord = currentSet.text_spa
        }
        if let alternateSet = alternateSet {
            self.currentSpanishWord = alternateSet.text_spa
        }
        self.resetTimer()
    }

    private func getRandomElementIndex(exceptionIndexes: [Int]) -> Int? {
        var availableSet = Set(0..<words.count)
        availableSet = availableSet.subtracting(exceptionIndexes)
        let index = availableSet.randomElement()
        if let index = index, index < words.count {
            return index
        }
        return nil
    }

    func evaluateAnswer(userSelected: Bool) {
        if userSelected && self.currentSpanishWord == self.currentSet?.text_spa {
            self.correctAnswer()
        } else if !userSelected && self.currentSpanishWord != self.currentSet?.text_spa {
            self.correctAnswer()
        } else {
            self.wrongAnswer()
        }
    }
    
    private func correctAnswer() {
        self.currentCorrectAnswers += 1
        self.checkGameState()
    }

    @objc private func wrongAnswer() {
        self.currentWrongAnswers += 1
        self.checkGameState()
    }

    private func checkGameState() {
        if self.currentWrongAnswers == 3 || (self.currentWrongAnswers + self.currentCorrectAnswers) == 15 {
            self.endGame()
            return
        }
        self.createQuestion()
    }

    func endGame() {
        self.gameState = .ended
        self.closeTimer()
    }

    private func resetTimer() {
        self.closeTimer()
        timer = Timer.scheduledTimer(timeInterval: 5,
                                     target: self,
                                     selector: #selector(wrongAnswer),
                                     userInfo: nil,
                                     repeats: false)
    }

    private func closeTimer() {
        timer?.invalidate()
        timer = nil
    }
}
