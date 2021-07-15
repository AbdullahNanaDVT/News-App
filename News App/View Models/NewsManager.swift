//
//  NetworkManager.swift
//  News App
//
//  Created by Abdullah Nana on 2021/07/14.
//

import Foundation
import CoreLocation

protocol NewsManagerDelegate {
    func updateNews(searchString: String, countryCode: String)
    func didFailWithError(error: Error)
}

class NewsManager: CLLocationManager {
    
    static let shared = NewsManager()
    private var newsDelegate: NewsManagerDelegate?
    private let locationManager = CLLocationManager()
    private var country = NSLocale.current.regionCode
    
    
    private let baseUrlString = "https://newsapi.org/v2/"
    private let topHeadline = "top-headlines?country=sa"
    
    func loadNewsData(searchString: String = "", countryCode:String = "", completion: @escaping ([NewsData]?) -> Void) {

        let baseUrlString = "https://newsapi.org/v2/"
        let topHeadline = "top-headlines?"
        //countryCode = country?.lowercased() ?? "ae"
        
        //let urlString = "\(baseUrlString)\(topHeadline)country=za&apiKey=\(APIKey.key)"

        var urlString = "\(baseUrlString)\(topHeadline)country=\(countryCode)&apiKey=\(APIKey.key)"

        if searchString == "" {
            urlString = "\(baseUrlString)\(topHeadline)country=\(countryCode)&apiKey=\(APIKey.key)"
        } else {
            urlString = "\(baseUrlString)\(topHeadline)q=\(searchString)&apiKey=\(APIKey.key)"
        }
        
        guard let url = URL(string: urlString) else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard error == nil, let data = data else {
                completion(nil)
                return
            }
            let newsResult = try? JSONDecoder().decode(NewsResults.self, from: data)
            newsResult == nil ? completion(nil) : completion(newsResult!.articles)
            self.newsDelegate?.updateNews(searchString: searchString, countryCode: countryCode)
        }.resume()
    }
}
