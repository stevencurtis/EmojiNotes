//
//  EmojiNotesUITests.swift
//  EmojiNotesUITests
//
//  Created by Steven Curtis on 21/06/2019.
//  Copyright © 2019 Steven Curtis. All rights reserved.
//

import XCTest

class EmojiNotesUITests: XCTestCase {

    let app = XCUIApplication()

    override func setUp() {
        continueAfterFailure = false
        XCUIApplication().launch()
    }

    override func tearDown() {
    }

    func testAddNote() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        app.navigationBars.buttons.element(boundBy: 0).tap() // go to add screen
        app.navigationBars.buttons.element(boundBy: 0).tap() // go back to notes
        let cell = app.collectionViews.children(matching: .cell).element(boundBy: app.collectionViews.cells.count - 1)
        XCTAssertTrue(cell.staticTexts["no emoji Titleless note"].exists )
    }
    
    func testComplexNote() {
        app.navigationBars.buttons.element(boundBy: 0).tap() // go to add screen
        app.buttons["Add to a category"].tap()
        sleep(1)
        app.buttons["Create a new category"].tap()
        sleep(1)
        app.buttons["Change colour"].tap()
        sleep(1)
        app.buttons["red"].tap()
        sleep(1)
        app.buttons["Change category"].tap()
        sleep(1)
        
        let textField = app.otherElements.textFields.element(boundBy: 0)
        
        textField.tap()
        textField.typeText("test")
        sleep(1)
        app.buttons["Submit"].tap()
        sleep(1)
        
        app.navigationBars.buttons.element(boundBy: 0).tap() // go back to notes
        sleep(1)

        let textFieldTitle = app.otherElements.textFields.element(boundBy: 0)
        textFieldTitle.tap()
        textFieldTitle.typeText("Note title")
        sleep(1)

        let textFieldContents = app.textViews["Contents"] // identifier
        textFieldContents.tap()
        textFieldContents.typeText("Note Contents")
        sleep(1)
        
        app.buttons["Choose Emoji"].tap()
        sleep(1)

        let cell = app.collectionViews.children(matching: .cell).element(boundBy: app.collectionViews.cells.count - 1)
        cell.tap()
        sleep(1)

        app.navigationBars.buttons.element(boundBy: 0).tap() // go back to notes
        
        let menuCell = app.collectionViews.children(matching: .cell).element(boundBy: app.collectionViews.cells.count - 1)
        menuCell.tap()
        sleep(1)
        
        XCTAssertTrue(app.staticTexts["Note title"].exists && app.staticTexts["Note Contents"].exists )
    }

}
