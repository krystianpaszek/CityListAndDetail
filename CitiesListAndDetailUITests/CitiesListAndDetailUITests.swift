//
//  CitiesListAndDetailUITests.swift
//  CitiesListAndDetailUITests
//
//  Created by Krystian Paszek on 14/11/2020.
//

import XCTest

class CitiesListAndDetailUITests: XCTestCase {

    // MARK: - Properties
    var app: XCUIApplication!

    // MARK: - Setup
    override func setUp() {
        super.setUp()

        continueAfterFailure = false
        app = XCUIApplication()
    }

    // MARK: - Tests
    func testThatItShowsTableView() {
        app.launch()

        let table = app.tables.element
        XCTAssertTrue(table.exists)
    }

    func testThatItHasRefreshButton() {
        let navigationBar = app.navigationBars["Cities"]
        let filterButton = navigationBar.buttons["Refresh"]
        XCTAssertNotNil(filterButton)
    }

    func testThatItHasFilterButton() {
        let navigationBar = app.navigationBars["Cities"]
        let filterButton = navigationBar.buttons["favorite"]
        XCTAssertNotNil(filterButton.exists)
    }
}
