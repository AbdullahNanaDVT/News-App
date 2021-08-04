//
//  NewsListViewModel.swift
//  News App
//
//  Created by Abdullah Nana on 2021/07/14.
//
import Foundation

class ChooseCountryViewModel {
    var newsArray = [ArticleResults]()
    private var countryNamePropertyListArray: NSArray?
    private var countryCodePropertyListArray: NSArray?
    private lazy var countryNameArray: [String] = []
    private lazy var countryCodeArray: [String] = []
    private lazy var countryLetterArray: [String] = []
    
    func fillCountryNames() {
        if let countryNamePath = Bundle.main.path(forResource: "Countries", ofType: "plist"),
           let countryCodePath = Bundle.main.path(forResource: "CountryCodes", ofType: "plist") {
            countryNamePropertyListArray = NSArray(contentsOfFile: countryNamePath)
            countryCodePropertyListArray = NSArray(contentsOfFile: countryCodePath)
            countryNameArray = countryNamePropertyListArray as? [String] ?? []
            countryCodeArray = countryCodePropertyListArray as? [String] ?? []
            countryNameArray = countryNameArray.sorted()
            
            for country in countryNameArray {
                let countryLetter = String(country.prefix(1))
                countryLetterArray.append(countryLetter)
            }
        }
    }
    
    var numberOfCountries: Int {
        countryNameArray.count
    }
    
    var countryCodes: [String] {
        countryCodeArray
    }
    
    var countryNames: [String] {
        countryNameArray
    }
    
    var countryPrefixes: [String] {
        let uniqueOrderedPrefixArray = NSOrderedSet(array: countryLetterArray).array as? [String] ?? []
        return uniqueOrderedPrefixArray
    }
    
    func convertToCountryCode(_ codeNumber: Int) -> String {
        countryCodeArray[codeNumber]
    }
}
