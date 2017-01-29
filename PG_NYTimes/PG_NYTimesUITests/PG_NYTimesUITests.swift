//
//  PG_NYTimesUITests.swift
//  PG_NYTimesUITests
//
//  Created by Samrat on 16/1/17.
//  Copyright © 2017 SMRT. All rights reserved.
//

import XCTest

class PG_NYTimesUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testCollectionViewInitialLoad() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let app = XCUIApplication()
        let firstChild = app.collectionViews.children(matching:.any).element(boundBy: 0)
        
        // Check if the collection view is displayed
        XCTAssertNotNil(firstChild)
        XCTAssertTrue(firstChild.isHittable)
        
        app.swipeUp()
        
    }
    
    func testCollectionViewDetailNavigation() {
        
        let app = XCUIApplication()
        let firstChild = app.collectionViews.children(matching:.any).element(boundBy: 0)
        
        // Check if the collection view is displayed
        XCTAssertNotNil(firstChild)
        XCTAssertTrue(firstChild.isHittable)
        
        firstChild.tap()
        
        // The list should be in the navigtion controller stack now
        XCTAssertFalse(firstChild.exists)
        
        // Assert that on tap we are navigating to the detail screen
        XCTAssertTrue(app.otherElements["URL"].exists)
        
        // Now check we can return back to the main screen
        XCTAssertTrue(app.buttons["Done"].exists)
        XCTAssertTrue(app.buttons["Done"].isHittable)
        
        app.buttons["Done"].tap()
        
        // Now the collection view should be visible
        XCTAssertTrue(firstChild.isHittable)
    }
    
    func testCollectionViewInfiniteLoading() {
        let app = XCUIApplication()
        var child = app.collectionViews.children(matching:.any).element(boundBy: 0)
        
        for _ in 0..<7 {
            child = app.collectionViews.children(matching:.any).element(boundBy: 0)
            child.swipeUp()
        }
        child = app.collectionViews.children(matching:.any).element(boundBy: 0)
        XCTAssertNotNil(child)
    }
    
    func testCollectionViewLoadingCount() {
        let app = XCUIApplication()
        var child = app.collectionViews.children(matching:.any).element(boundBy: 10)
        XCTAssertNotNil(child)
        
        child = app.collectionViews.children(matching:.any).element(boundBy: 20)
        XCTAssertNotNil(child)
        
    }
}
