//
//  NetworkManager.swift
//  News App
//
//  Created by Abdullah Nana on 2021/07/14.
//

import Foundation

class NewsManager {
    static let shared = NewsManager()
    internal var totalResults = 0
    
    func loadNewsData(searchString: String = "", countryCode: String = "", completion: @escaping ([NewsData]?) -> Void) {
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
}
