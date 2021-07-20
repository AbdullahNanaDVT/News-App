//
//  News_AppTests.swift
//  News AppTests
//
//  Created by Abdullah Nana on 2021/07/01.
//

import XCTest
@testable import News_App

class NewsAppTests: XCTestCase {
    private var logic = NewsListViewModel()

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        logic = NewsListViewModel()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testNumberOfCountries() throws {
        logic.fillCountryNames()
        let num = logic.getNumberOfCountries()
        XCTAssertEqual(num, 53, "Number of countries in list not equal")
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
