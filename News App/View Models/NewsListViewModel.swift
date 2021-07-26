//
//  NewsListViewModel.swift
//  News App
//
//  Created by Abdullah Nana on 2021/07/14.
//
import Foundation

class NewsListViewModel {
    internal var newsArray = [NewsViewModel]()
    private var countryNamePropertyListArray: NSArray?
    private var countryCodePropertyListArray: NSArray?
    private var countryNameArray: [String] = []
    private var countryCodeArray: [String] = []
    private var countryLetterArray: [String] = []
    private var countryCode = NSLocale.current.regionCode?.lowercased()
    
    internal func loadNewsData(searchString: String = "", countryCode: String = "", completion:@escaping ([NewsViewModel]) -> Void) {
        NewsManager.shared.loadNewsData(searchString: searchString, countryCode: countryCode) { (news) in
            guard let news = news else {return}
            let newsVM = news.map(NewsViewModel.init)
            DispatchQueue.main.async {
                self.newsArray = newsVM
                completion(newsVM)
            }
        }
    }
    
    internal func fillCountryNames() {
        if let countryNamePath = Bundle.main.path(forResource: "Countries", ofType: "plist"),
           let countryCodePath = Bundle.main.path(forResource: "CountryCodes", ofType: "plist") {
            countryNamePropertyListArray = NSArray(contentsOfFile: countryNamePath)
            countryCodePropertyListArray = NSArray(contentsOfFile: countryCodePath)
            countryNameArray = countryNamePropertyListArray as? [String] ?? []
            countryCodeArray = countryCodePropertyListArray as? [String] ?? []
            countryNameArray = countryNameArray.sorted()
            countryCodeArray = countryCodeArray.sorted()
            
            for country in countryNameArray {
                let countryLetter = String(country.prefix(1))
                countryLetterArray.append(countryLetter)
            }
        }
    }
    
    internal func getNumberOfCountries() -> Int {
        countryNameArray.count
    }
    
    internal func getNumberOfNewsResults() -> Int {
        newsArray.count
    }
    
    internal func getCountryCodes() -> [String] {
        countryCodeArray
    }
    
    internal func getNewsResults() -> [NewsViewModel] {
        newsArray
    }
    
    internal func getCountryNames() -> [String] {
        countryNameArray
    }
    
    internal func getCountryPrefixes() -> [String] {
        countryLetterArray
    }
    
    internal func getCountryCode() -> String {
        countryCode ?? "za"
    }
    
    internal func setCountryCode(_ code: String) -> String {
        countryCode = code
        return countryCode ?? "za"
    }
}
