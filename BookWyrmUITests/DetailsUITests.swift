//
//  DetailsUITests.swift
//  BookWyrmUITests
//
//  Created by Zaheer Moola on 2019/03/19.
//  Copyright © 2019 DVT. All rights reserved.
//

import XCTest

class DetailsUITests: XCTestCase {
    let app = XCUIApplication()

    override func setUp() {
        continueAfterFailure = false
        app.launchArguments.append("Testing")
    }

    override func tearDown() {

    }
   
    func testReadBookHasFilledBookmarkAndKnownBookHasReviews() {
        app.launch()
        openChamberOfSecrets()
        sleep(1)
        
        XCTAssert(app.staticTexts["ISBN_13: 9781781100509"].exists)
        XCTAssert(app.buttons["reviews"].exists)
        XCTAssert(app.buttons["bookmarkFilled"].exists)
    }
    
    func testUnreadBookDoestHaveBookmarkAndUnknownBookHasNoReviews() {
        app.launch()
        openReadingHarryPotter()
        sleep(1)
        XCTAssert(!app.buttons["reviews"].exists)
        XCTAssert(app.buttons["bookmark"].exists)
    }
    
    func testAddingBookToShelfModifiesButton() {
        app.launch()
        openReadingHarryPotter()
        let bookmarkButton = app.buttons["bookmark"]
        bookmarkButton.tap()
        sleep(1)
        XCTAssert(app.buttons["bookmarkFilled"].exists)
    }
    
    func testRemovingBookFromShelfModifiesButton() {
        app.launch()
        openChamberOfSecrets()
        let bookmarkButton = app.buttons["bookmarkFilled"]
        bookmarkButton.tap()
        sleep(1)
        XCTAssert(app.buttons["bookmark"].exists)
    }
    
    func testClickingReadingLinkOpensWebview() {
        app.launch()
        openChamberOfSecrets()
        let button = app.buttons["readingLink"]
        button.tap()
        sleep(5)
        XCTAssert(app.staticTexts["Book 2"].exists)
    }
    
    func testOpeningMyReviewPage() {
        app.launch()
        openChamberOfSecrets()
        let reviewsButton = app.buttons["reviews"]
        reviewsButton.tap()
        app.staticTexts["My Review"].tap()
        XCTAssert(app.navigationBars["Review for: Harry Potter and the Chamber of Secrets"].exists)
    }
    
    func testOpeningCriticReviewPage() {
        app.launch()
        openChamberOfSecrets()
        let reviewsButton = app.buttons["reviews"]
        reviewsButton.tap()
        app.staticTexts["Critic Reviews"].tap()
        sleep(1)
        XCTAssert(app.navigationBars["Reviews for: Harry Potter and the Chamber of Secrets"].exists)
    }
    
    func testErrorPopup() {
        app.launchArguments.append("Error")
        app.launch()
        openChamberOfSecrets()
        sleep(2)
        XCTAssertEqual(app.alerts.element.label, "Network Error")
    }
    
    func openReadingHarryPotter() {
        let sorryNoBooksFoundTable = app.tables[" Sorry, No books found "]
        sorryNoBooksFoundTable.searchFields["Search for a Book"].tap()
        let hKey = app/*@START_MENU_TOKEN@*/.keys["H"]/*[[".keyboards.keys[\"H\"]",".keys[\"H\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        hKey.tap()
        let aKey = app/*@START_MENU_TOKEN@*/.keys["a"]/*[[".keyboards.keys[\"a\"]",".keys[\"a\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        aKey.tap()
        let rKey = app/*@START_MENU_TOKEN@*/.keys["r"]/*[[".keyboards.keys[\"r\"]",".keys[\"r\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        rKey.tap()
        rKey.tap()
        let yKey = app/*@START_MENU_TOKEN@*/.keys["y"]/*[[".keyboards.keys[\"y\"]",".keys[\"y\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        yKey.tap()
        let spaceKey = app.keys["space"]
        spaceKey.tap()
        app/*@START_MENU_TOKEN@*/.buttons["shift"]/*[[".keyboards.buttons[\"shift\"]",".buttons[\"shift\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        let pKey = app/*@START_MENU_TOKEN@*/.keys["P"]/*[[".keyboards.keys[\"P\"]",".keys[\"P\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        sleep(1)
        pKey.tap()
        sorryNoBooksFoundTable.staticTexts["Reading Harry Potter"].tap()
    }
    
    func openChamberOfSecrets() {
        let sorryNoBooksFoundTable = app.tables[" Sorry, No books found "]
        sorryNoBooksFoundTable.searchFields["Search for a Book"].tap()
        
        let hKey = app/*@START_MENU_TOKEN@*/.keys["H"]/*[[".keyboards.keys[\"H\"]",".keys[\"H\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        hKey.tap()
        let aKey = app/*@START_MENU_TOKEN@*/.keys["a"]/*[[".keyboards.keys[\"a\"]",".keys[\"a\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        aKey.tap()
        let rKey = app/*@START_MENU_TOKEN@*/.keys["r"]/*[[".keyboards.keys[\"r\"]",".keys[\"r\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        rKey.tap()
        rKey.tap()
        let yKey = app/*@START_MENU_TOKEN@*/.keys["y"]/*[[".keyboards.keys[\"y\"]",".keys[\"y\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        yKey.tap()
        let spaceKey = app.keys["space"]
        spaceKey.tap()
        app/*@START_MENU_TOKEN@*/.buttons["shift"]/*[[".keyboards.buttons[\"shift\"]",".buttons[\"shift\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        let pKey = app/*@START_MENU_TOKEN@*/.keys["P"]/*[[".keyboards.keys[\"P\"]",".keys[\"P\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        pKey.tap()
        let oKey = app/*@START_MENU_TOKEN@*/.keys["o"]/*[[".keyboards.keys[\"o\"]",".keys[\"o\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        oKey.tap()
        let tKey = app/*@START_MENU_TOKEN@*/.keys["t"]/*[[".keyboards.keys[\"t\"]",".keys[\"t\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        tKey.tap()
        tKey.tap()
        let eKey = app/*@START_MENU_TOKEN@*/.keys["e"]/*[[".keyboards.keys[\"e\"]",".keys[\"e\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        eKey.tap()
        rKey.tap()
        spaceKey.tap()
        
        aKey.tap()
        let nKey = app/*@START_MENU_TOKEN@*/.keys["n"]/*[[".keyboards.keys[\"n\"]",".keys[\"n\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        nKey.tap()
        let dKey = app/*@START_MENU_TOKEN@*/.keys["d"]/*[[".keyboards.keys[\"d\"]",".keys[\"d\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        dKey.tap()
        spaceKey.tap()
        tKey.tap()
        let hKey2 = app/*@START_MENU_TOKEN@*/.keys["h"]/*[[".keyboards.keys[\"h\"]",".keys[\"h\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        hKey2.tap()
        eKey.tap()
        spaceKey.tap()
        
        let cKey = app/*@START_MENU_TOKEN@*/.keys["c"]/*[[".keyboards.keys[\"c\"]",".keys[\"c\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        cKey.tap()
        hKey2.tap()
        aKey.tap()
        let mKey = app/*@START_MENU_TOKEN@*/.keys["m"]/*[[".keyboards.keys[\"m\"]",".keys[\"m\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        mKey.tap()
        let bKey = app/*@START_MENU_TOKEN@*/.keys["b"]/*[[".keyboards.keys[\"b\"]",".keys[\"b\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        bKey.tap()
        eKey.tap()
        sleep(1)
        rKey.tap()
        
        let firstItem = app.cells.element(boundBy: 0)
        firstItem.tap()
    }
}
