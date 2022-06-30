//
//  WordGameUITests.swift
//  WordGameUITests
//
//  Created by Yasin Taşkıran on 28.06.2022.
//

import XCTest

class WordGameUITests: XCTestCase {

    func testExample() throws {
        let app = XCUIApplication()
        app.launch()

        let welcome = app.staticTexts["Welcome to the Game"]
        XCTAssert(welcome.exists)
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
