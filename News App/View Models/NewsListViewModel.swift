//
//  NewsListViewModel.swift
//  News App
//
//  Created by Abdullah Nana on 2021/07/14.
//
import Foundation

class NewsListViewModel {
    var newsArray = [NewsViewModel]()
    private var countryNamePropertyListArray: NSArray?
    private var countryCodePropertyListArray: NSArray?
    private lazy var countryNameArray: [String] = []
    private lazy var countryCodeArray: [String] = []
    private lazy var countryLetterArray: [String] = []
    private lazy var countryCodeLocation = NSLocale.current.regionCode?.lowercased()
    
    func loadNewsData(searchString: String = "", countryCode: String = "", completion:@escaping ([NewsViewModel]) -> Void) {
        NewsManager.shared.loadNewsData(searchString: searchString, countryCode: countryCode) { (news) in
            guard let news = news else {return}
            let newsVM = news.map(NewsViewModel.init)
            DispatchQueue.main.async {
                self.newsArray = newsVM
                completion(newsVM)
            }
        }
    }
    
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

    var numberOfNewsResults: Int {
        newsArray.count
    }
    
    var countryCodes: [String] {
        countryCodeArray
    }
    
    var newsResults: [NewsViewModel] {
        newsArray
    }
    
    var countryNames: [String] {
        countryNameArray
    }
    
    var countryPrefixes: [String] {
        countryLetterArray
    }
    
    var countryCode: String {
        countryCodeLocation ?? "za"
    }
    
    func changeCountryCode(_ codeNumber: Int) {
        countryCodeLocation = countryCodeArray[codeNumber]
    }
}
