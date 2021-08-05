//
//  NetworkManager.swift
//  News App
//
//  Created by Abdullah Nana on 2021/07/14.
//

import Foundation
import CoreLocation
import MapKit
import SystemConfiguration

class NewsViewModel: NSObject, CLLocationManagerDelegate {
    
    private var newsArray = [ArticleResults]()
    static let shared = NewsViewModel()
    private var totalResults = 1
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
        } else {
            print(NSLocalizedString("LOCATION_NOT_ENABLED", comment: ""))
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
            print("No results")
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            guard error == nil, let data = data else {
                completion(nil)
                print("No results")
                return
            }
            let newsResult = try? JSONDecoder().decode(NewsResults.self, from: data)
            newsResult == nil ? self.totalResults = 0 : completion(newsResult!.articles)
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
    
    func isInternetAvailable() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        return (isReachable && !needsConnection)
    }
    
    func countryCode(for country: String) {
        countryCode = country
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

    var noResultsAlertTitle: String {
        NSLocalizedString("ALERT_TITLE", comment: "")
    }
    
    var searchAlertMessage: String {
        NSLocalizedString("ALERT_MESSAGE", comment: "")
    }
    
    var actionTitle: String {
        NSLocalizedString("ALERT_ACTION_TITLE", comment: "")
    }
    
    var warningAlertTitle: String {
        NSLocalizedString("WARNING", comment: "")
    }
    
    var noInternetMessage: String {
        NSLocalizedString("NO_INTERNET_MESSAGE", comment: "")
    }
}
