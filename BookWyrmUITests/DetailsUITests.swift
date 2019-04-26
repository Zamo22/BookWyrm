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
        let expect = XCTestExpectation(description: "Pages: 341")
        _ = XCTWaiter.wait(for: [expect], timeout: 11)

        XCTAssert(app.staticTexts["Pages: 341"].exists)
        XCTAssert(app.staticTexts["Guardian"].exists)
        XCTAssert(app.buttons["bookmarkFilled2"].exists)
    }
    
    func testUnreadBookDoestHaveBookmarkAndUnknownBookHasNoReviews() {
        app.launch()
        openReadingHarryPotter()
        sleep(3)
        //XCTAssert(!app.buttons["reviews"].exists)
        XCTAssert(app.buttons["bookmark2"].exists)
    }
    
    func testAddingBookToShelfModifiesButton() {
        app.launch()
        openReadingHarryPotter()
        let bookmarkButton = app.buttons["bookmark2"]
        bookmarkButton.tap()
        sleep(3)
        XCTAssert(app.buttons["bookmarkFilled2"].exists)
    }
    
    func testRemovingBookFromShelfModifiesButton() {
        app.launch()
        openChamberOfSecrets()
        let bookmarkButton = app.buttons["bookmarkFilled2"]
        bookmarkButton.tap()
        sleep(1)
        XCTAssert(app.buttons["bookmark2"].exists)
    }
    
    func testClickingReadingLinkOpensWebview() {
        app.launch()
        openChamberOfSecrets()
        let button = app.buttons["Book Link"]
        button.tap()
        let expect = XCTestExpectation(description: "Harry Potter and the Chamber of Secrets")
        _ = XCTWaiter.wait(for: [expect], timeout: 10)
        XCTAssert(app.staticTexts["Harry Potter and the Chamber of Secrets"].exists)
    }
    
    func testOpeningMyReviewPage() {
        app.launch()
        openChamberOfSecrets()
        sleep(3)
        let reviewsButton = app.buttons["Leave a Review"]
        reviewsButton.tap()
        let expect = XCTestExpectation(description: "Review for: Harry Potter and the Chamber of Secrets")
         _ = XCTWaiter.wait(for: [expect], timeout: 12)
        XCTAssert(app.navigationBars["Review for: Harry Potter and the Chamber of Secrets"].exists)
    }
    
    func testOpeningCriticReviewPage() {
        app.launch()
        openChamberOfSecrets()
        let reviewsButton = app.buttons["SEE ALL"]
        reviewsButton.tap()
        sleep(3)
        XCTAssert(app.navigationBars["Reviews for: Harry Potter and the Chamber of Secrets"].exists)
    }
    
    func testErrorPopup() {
        app.launchArguments.append("Error")
        app.launch()
        openChamberOfSecrets()
        sleep(2)
        XCTAssertEqual(app.alerts.element.label, "Network Error")
    }
    
    func testOpeningSimilarBooks() {
        app.launch()
        openChamberOfSecrets()
        let scrollViewsQuery = app.scrollViews
        scrollViewsQuery.otherElements.containing(.staticText, identifier: "Harry Potter and the Chamber of Secrets").element.swipeUp()
        let harryPotterAndTheChamberOfSecretsElementsQuery = scrollViewsQuery.otherElements.containing(.staticText, identifier: "Harry Potter and the Chamber of Secrets")
        harryPotterAndTheChamberOfSecretsElementsQuery.children(matching: .image).element(boundBy: 2).tap()
        sleep(1)
        XCTAssert(app.staticTexts["Lord of the Flies"].exists)
        app.navigationBars["BookWyrm.NewDetailView"].buttons["Back"].tap()
        harryPotterAndTheChamberOfSecretsElementsQuery.children(matching: .image).element(boundBy: 3).tap()
        sleep(1)
        XCTAssert(app.staticTexts["A Wrinkle in Time (Time Quintet, #1)"].exists)
        app.navigationBars["BookWyrm.NewDetailView"].buttons["Back"].tap()
        harryPotterAndTheChamberOfSecretsElementsQuery.children(matching: .image).element(boundBy: 4).tap()
        sleep(1)
        XCTAssert(app.staticTexts["Speak"].exists)
        app.navigationBars["BookWyrm.NewDetailView"].buttons["Back"].tap()
        harryPotterAndTheChamberOfSecretsElementsQuery.children(matching: .image).element(boundBy: 5).tap()
        sleep(1)
        XCTAssert(app.staticTexts["By: Lewis Carroll"].exists)
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
