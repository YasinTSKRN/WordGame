//
//  WordGameTests.swift
//  WordGameTests
//
//  Created by Yasin Taşkıran on 28.06.2022.
//

import XCTest
@testable import WordGame

class WordGameTests: XCTestCase {
    
    let handler = ContentHandler(words: [WordSet(text_eng: "ENG", text_spa: "SPA")])

    override func setUp() {
        handler.gameState = .initialize
    }

    override func tearDown() {
        handler.endGame()
    }

    func testGameStart() {
        handler.startGame()
        XCTAssertEqual(handler.currentEnglishWord, "ENG")
        XCTAssertEqual(handler.currentSpanishWord, "SPA")
    }

    func testCorrectAnswer() {
        handler.startGame()
        handler.evaluateAnswer(userSelected: true)
        XCTAssertEqual(handler.currentCorrectAnswers, 1)
        XCTAssertEqual(handler.currentWrongAnswers, 0)
    }
    
    func testWrongAnswer() {
        handler.startGame()
        handler.evaluateAnswer(userSelected: false)
        XCTAssertEqual(handler.currentWrongAnswers, 1)
        XCTAssertEqual(handler.currentCorrectAnswers, 0)
    }

    func testGameEnd() {
        handler.startGame()
        handler.evaluateAnswer(userSelected: true)
        XCTAssertEqual(handler.gameState, .ended)
    }

    func testGameTimer() {
        let expectation = self.expectation(description: "testGameTimer")
        let expectedTime: Double = 5
        
        handler.startGame()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + expectedTime) {
            expectation.fulfill()
        }
        waitForExpectations(timeout: expectedTime+1)
        XCTAssertEqual(handler.gameState, .ended)
        XCTAssertEqual(handler.currentWrongAnswers, 1)
        XCTAssertEqual(handler.currentCorrectAnswers, 0)
    }
}
