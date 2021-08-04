//
//  NetworkManager.swift
//  News App
//
//  Created by Abdullah Nana on 2021/07/14.
//

import Foundation
import CoreLocation
import MapKit

class NewsViewModel: NSObject, CLLocationManagerDelegate {
    
    private var newsArray = [ArticleResults]()
    static let shared = NewsViewModel()
    private var totalResults = 0
    let locationManager = CLLocationManager()
    private let geoCoder = CLGeocoder()
    private var countryCode = ""
    weak var delegate: ChooseCountryDelegate?
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationSetup()
    }
    
    func locationSetup() {
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    func geoLocation(from location: CLLocation, completion: @escaping (_ country: String?, _ error: Error?) -> Void) {
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
            completion(placemarks?.first?.country, error)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location: CLLocation = manager.location else { return }
        geoLocation(from: location) { country, error in
            guard let country = country, error == nil else { return }
            self.countryCode = self.countryToCountryCode(for: country).lowercased()
            self.delegate?.didChangeCountry(to: self.countryCode)
            print("locationManager: \(self.countryCode)")
        }
    }
    
    func countryToCountryCode(for fullCountryName: String) -> String {
        let codeForCountry: String = ""
        for localeCode in NSLocale.isoCountryCodes {
            let identifier = NSLocale(localeIdentifier: localeCode)
            let countryName = identifier.displayName(forKey: NSLocale.Key.countryCode, value: localeCode)
            if fullCountryName.lowercased() == countryName?.lowercased() {
                return localeCode
            }
        }
        return codeForCountry
    }
    
    func newsData(searchString: String = "", countryCode: String = "", completion: @escaping ([Article]?) -> Void) {
        let baseUrlString = "https://newsapi.org/v2/"
        let topHeadline = "top-headlines?"
        var urlString = "\(baseUrlString)\(topHeadline)country=\(countryCode)&apiKey=\(APIKey.key)"

        if searchString.isEmpty {
            urlString = "\(baseUrlString)\(topHeadline)country=\(countryCode)&apiKey=\(APIKey.key)"
        } else {
            urlString = "\(baseUrlString)\(topHeadline)q=\(searchString)&apiKey=\(APIKey.key)"
        }
        
        guard let url = URL(string: urlString) else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            guard error == nil, let data = data else {
                completion(nil)
                return
            }
            let newsResult = try? JSONDecoder().decode(NewsResults.self, from: data)
            self.totalResults = newsResult?.totalResults ?? 0
            newsResult == nil ? completion(nil) : completion(newsResult!.articles)
        }.resume()
    }
    
    func mapNewsData(searchString: String = "", countryCode: String = "", completion:@escaping ([ArticleResults]) -> Void) {
        NewsViewModel.shared.newsData(searchString: searchString, countryCode: countryCode) { (news) in
            guard let news = news else {return}
            let newsVM = news.map(ArticleResults.init)
            DispatchQueue.main.async {
                self.newsArray = newsVM
                completion(newsVM)
            }
        }
    }
    
    var numberOfNewsResults: Int {
        newsArray.count
    }
    
    var newsResults: [ArticleResults] {
        newsArray
    }
    
    var country: String {
        countryCode
    }
    
    func countryCode(for country: String) -> String {
        countryCode = country
        print("countryCode: \(countryCode)")
        return countryCode
    }
}
