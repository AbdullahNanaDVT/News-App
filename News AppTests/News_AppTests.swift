//
//  News_AppTests.swift
//  News AppTests
//
//  Created by Abdullah Nana on 2021/07/01.
//

import XCTest
@testable import News_App

class NewsAppTests: XCTestCase {
    private lazy var chooseCountryViewModelLogic = ChooseCountryViewModel()
    private lazy var newsViewModelLogic = NewsViewModel()

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        chooseCountryViewModelLogic = ChooseCountryViewModel()
        newsViewModelLogic = NewsViewModel()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testNumberOfCountries() throws {
        chooseCountryViewModelLogic.fillCountryNames()
        let num = chooseCountryViewModelLogic.numberOfCountries
        XCTAssertEqual(num, 36, "Number of countries in list not equal")
    }
    func testNumberOfNewsResults() throws {
        let count = newsViewModelLogic.newsResults.count
        let numberOfCountries = newsViewModelLogic.numberOfNewsResults
        XCTAssertEqual(numberOfCountries, count, "Number of news results are not equal")
    }
    func testCountryCodeArray() throws {
        chooseCountryViewModelLogic.fillCountryNames()
        let testArray = chooseCountryViewModelLogic.countryCodes
        let countryCodeArray = ["ar", "au", "be", "br", "ca", "cn", "eg", "fr", "de",
                                "gb", "gr", "hk", "hu", "in", "id", "ie", "it", "jp",
                                "lv", "lt", "my", "mx", "nl", "nz", "ng", "pl", "pt",
                                "ru", "sa", "sg", "za", "th", "tr", "us", "ae", "ve"]
        XCTAssertEqual(countryCodeArray, testArray, "Country code arrays not equal not equal")
    }
    func testCountryNameArray() throws {
        chooseCountryViewModelLogic.fillCountryNames()
        let testArray = chooseCountryViewModelLogic.countryNames
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
