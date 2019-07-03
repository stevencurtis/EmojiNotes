//
//  UIColorisDarkColorTest.swift
//  EmojiNotesTests
//
//  Created by Steven Curtis on 03/07/2019.
//  Copyright © 2019 Steven Curtis. All rights reserved.
//

import XCTest
import CoreData
@testable import EmojiNotes

class UIColorisDarkColorTest: XCTestCase {

    override func setUp() {
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testPurpleDark() {
        XCTAssertEqual(true, UIColor.purple.isDarkColor)
    }
    
    func testBlueDark() {
        XCTAssertEqual(true, UIColor.blue.isDarkColor)
    }
    
    func testBlackDark() {
        XCTAssertEqual(true, UIColor.black.isDarkColor)
    }
    
    func testWhiteDark() {
        XCTAssertEqual(false, UIColor.white.isDarkColor)
    }
    
}
