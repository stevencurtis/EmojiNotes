//
//  UIColorNameTests.swift
//  EmojiNotesTests
//
//  Created by Steven Curtis on 03/07/2019.
//  Copyright © 2019 Steven Curtis. All rights reserved.
//

import XCTest
import CoreData
@testable import EmojiNotes

class UIColorNameTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testBlackName(){
        XCTAssertEqual("black", UIColor.black.name)
    }

    func testdarkGrayName(){
        XCTAssertEqual("darkGray", UIColor.darkGray.name)
    }
    
    func testLightGrayName(){
        XCTAssertEqual("lightGray", UIColor.lightGray.name)
    }
    
    func testWhiteName(){
        XCTAssertEqual("white", UIColor.white.name)
    }
    
    func testGrayName(){
        XCTAssertEqual("gray", UIColor.gray.name)
    }
    
    func testRedName(){
        XCTAssertEqual("red", UIColor.red.name)
    }
    
    func testBlueName(){
        XCTAssertEqual("blue", UIColor.blue.name)
    }
    
    func testCyanName(){
        XCTAssertEqual("cyan", UIColor.cyan.name)
    }
    
    func testYellowName(){
        XCTAssertEqual("yellow", UIColor.yellow.name)
    }
    
    func testMagentaName(){
        XCTAssertEqual("magenta", UIColor.magenta.name)
    }

    func testOrangeName(){
        XCTAssertEqual("orange", UIColor.orange.name)
    }
    
    func testPurpleName(){
        XCTAssertEqual("purple", UIColor.purple.name)
    }
    
    func testBrownName(){
        XCTAssertEqual("brown", UIColor.brown.name)
    }
}
