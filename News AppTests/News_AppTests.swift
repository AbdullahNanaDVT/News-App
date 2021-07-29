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
        XCTAssertEqual(num, 36, "Number of countries in list not equal")
    }
    func testNumberOfNewsResults() throws {
        let count = logic.newsArray.count
        let numberOfCountries = logic.getNumberOfNewsResults()
        XCTAssertEqual(numberOfCountries, count, "Number of news results are not equal")
    }
    func testCountryCodeArray() throws {
        logic.fillCountryNames()
        let testArray = logic.getCountryCodes()
        let countryCodeArray = ["ar", "au", "be", "br", "ca", "cn", "eg", "fr", "de",
                                "gb", "gr", "hk", "hu", "in", "id", "ie", "it", "jp",
                                "lv", "lt", "my", "mx", "nl", "nz", "ng", "pl", "pt",
                                "ru", "sa", "sg", "za", "th", "tr", "us", "ae", "ve"]
        XCTAssertEqual(countryCodeArray, testArray, "Country code arrays not equal not equal")
    }
    func testCountryNameArray() throws {
        logic.fillCountryNames()
        let testArray = logic.getCountryNames()
        let countryNameArray = ["Argentina", "Austria", "Belgium", "Brazil", "Canada",
                                "China", "Egypt", "France", "Germany",
                                "Great Britain", "Greece", "Honk Kong",
                                "Hungary", "India", "Indonesia", "Ireland", "Italy",
                                "Japan", "Latvia", "Lithuania", "Malaysia", "Mexico",
                                "Netherlands", "New Zealand", "Nigeria",
                                "Poland", "Portugal", "Russia", "Saudi Arabia", "Singapore",
                                "South Africa", "Thailand", "Turkey",
                                "USA", "United Arab Emirates", "Venezuela"]
        let sortedArray = countryNameArray.sorted()
        XCTAssertEqual(sortedArray, testArray, "Country code arrays not equal not equal")
    }
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
