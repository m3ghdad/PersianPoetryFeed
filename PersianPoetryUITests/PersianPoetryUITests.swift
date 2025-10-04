//
//  PersianPoetryUITests.swift
//  PersianPoetryUITests
//
//  Created by Meghdad Abbaszadegan on 10/3/25.
//

import XCTest

final class PersianPoetryUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
        // Put teardown code here
    }

    func testExample() throws {
        let app = XCUIApplication()
        app.launch()
        XCTAssertTrue(app.exists)
    }

    func testLaunchPerformance() throws {
        if #available(iOS 16.0, *) {
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
