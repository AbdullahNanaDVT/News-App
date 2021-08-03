//
//  NetworkManager.swift
//  News App
//
//  Created by Abdullah Nana on 2021/07/14.
//

import Foundation

class NewsViewModel {
    private var newsArray = [ArticleResults]()
    static let shared = NewsViewModel()
    private var totalResults = 0
    
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
}
