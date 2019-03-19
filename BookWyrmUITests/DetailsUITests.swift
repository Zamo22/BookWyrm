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
        app.launch()
    }

    override func tearDown() {

    }
   
}
