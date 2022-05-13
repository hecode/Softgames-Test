//
//  Softgames_TestTests.swift
//  Softgames TestTests
//
//  Created by ibrahim beltagy on 13/05/2022.
//

import XCTest
@testable import Softgames_Test

class Softgames_TestTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testGetDateFromStringNotDate() throws {
        let date = "test"
        XCTAssertNil(getDateFromString(dateStr: date))
    }

    func testGetDateFromStringWrongDateFormat() throws {
        let date = "01-11-2000"
        XCTAssertNil(getDateFromString(dateStr: date))
    }

    func testGetDateFromStringCorrect() throws {
        let date = "2000-11-01"
        XCTAssertNotNil(getDateFromString(dateStr: date))
    }
    
    func testYearsBetweenDatesEqual() throws {
        let date1 = getDateFromString(dateStr: "2000-11-01")!
        let date2 = getDateFromString(dateStr: "2000-11-01")!

        XCTAssertEqual(yearsBetweenDates(startDate: date1, endDate: date2), 0)
    }
    
    func testYearsBetweenDates20Years() throws {
        let date1 = getDateFromString(dateStr: "2000-11-01")!
        let date2 = getDateFromString(dateStr: "2020-11-01")!

        XCTAssertEqual(yearsBetweenDates(startDate: date1, endDate: date2), 20)
    }
    
    func testYearsBetweenDates10YearsInTheFuture() throws {
        let date1 = getDateFromString(dateStr: "2030-11-01")!
        let date2 = getDateFromString(dateStr: "2020-11-01")!

        XCTAssertEqual(yearsBetweenDates(startDate: date1, endDate: date2), -10)
    }
    
}
