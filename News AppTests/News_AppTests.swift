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
    func testNumberOfNewsResults() throws {
        let count = logic.newsArray.count
        let numberOfCountries = logic.getNumberOfNewsResults()
        XCTAssertEqual(numberOfCountries, count, "Number of news results are not equal")
    }
    func testCountryCodeArray() throws {
        logic.fillCountryNames()
        let testArray = logic.getCountryCodes()
        let countryCodeArray = ["ae", "ar", "at", "au", "be", "bg", "br", "ca", "ch", "cn",
                                               "co", "cu", "cz", "de", "eg", "fr", "gb", "gr", "hk", "hu",
                                               "id", "ie", "il", "in", "it", "jp", "kr", "lt", "lv", "ma",
                                               "mx", "my", "ng", "nl", "no", "nz", "ph", "pl", "pt", "ro",
                                               "rs", "ru", "sa", "se", "sg", "si", "sk", "th", "tr", "tw",
                                               "ua", "us", "ve", "za"]
        XCTAssertEqual(countryCodeArray, testArray, "Country code arrays not equal not equal")
    }
    func testCountryNameArray() throws {
        logic.fillCountryNames()
        let testArray = logic.getCountryNames()
        let countryNameArray = ["United Arab Emirates", "Argentina", "Austria", "Australia", "Belgium", "Bulgaria",
                                "Brazil", "Canada", "Switzerland", "China",
                                "Colombia", "Cuba", "Czech Republic", "Germany", "Egyp", "France", "Great Britain",
                                "Greece", "Honk Kong", "Hungary",
                                "Indonesia", "Ireland", "India", "Italy", "Japan", "South Korea",
                                "Lithuania", "Latvia", "Marocco",
                                "Mexico", "Malaysia", "Nigeria", "Netherlands", "Norway", "New Zealand", "Philippines",
                                "Poland", "Portugal", "Romania",
                                "Serbia", "Russia", "Saudi Arabia", "Sweden", "Singapore", "Slovenia", "Slovakia",
                                "Thailand", "Turkey", "Taiwan",
                                "Ukraine", "USA", "Venezuela", "South Africa"]
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
