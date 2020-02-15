//
//  FoodTrackerTests.swift
//  FoodTrackerTests
//
//  Created by Winnie Hou on 2020-01-21.
//  Copyright © 2020 Winnie Hou. All rights reserved.
//

import XCTest
@testable import FoodTracker

//write functional test: work as expected
//write performance test: work as fast as expected

class FoodTrackerTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    // MARK: Meal Class Tests
    func testMealInitializationSucceeds () {
        // Zero Rating
        let zeroRatingMeal = Meal.init(name: "Zero", photo: nil, rating: 0)
        XCTAssertNotNil(zeroRatingMeal)
    
        // Highest Positive Rating
        let highestPositiveMeal = Meal.init(name: "Positive", photo: nil, rating: 5)
        XCTAssertNotNil(highestPositiveMeal)
    }
    
    func testMealInitializationFails() {
        //Negative Rating
        let negativeRatingMeal = Meal.init(name: "Negative", photo: nil, rating: -1)
        XCTAssertNil(negativeRatingMeal)
        
        //Rating exceeds maximum
        let largeRatingMeal = Meal.init(name: "Large", photo: nil, rating: 6)
        XCTAssertNil(largeRatingMeal)
        
        //Empty String
        let emptyStringMeal = Meal.init(name: "", photo: nil, rating: 0)
        XCTAssertNil(emptyStringMeal)
    }
}

