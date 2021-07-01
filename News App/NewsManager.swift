//
//  NewsManager.swift
//  News App
//
//  Created by Abdullah Nana on 2021/07/01.
//

import Foundation

//protocol NewsManagerDelegate {
//    func didUpdateNews(_ newsManager: NewsManager, news: NewsModel)
//    func didFailWithError(error: Error)
//}

class NewsManager {
    var newsArray: [NewsModel] = []
    private let baseUrlString = "https://newsapi.org/v2/"
    private let topHeadline = "top-headlines?country=sa"
    
    //var delegate: NewsManagerDelegate?
    
    func fetchNews() {
        //let urlString = "\(baseUrlString)\(topHeadline)&apiKey=\(APIKey.key)"
        let urlString = "https://newsapi.org/v2/top-headlines?country=sa&category=business&apiKey=c48088d2c6704e9692a00e6de346f105"
        performRequest(with: urlString)
    }

    func performRequest(with urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    //self.delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safeData = data {
                    if let news = self.parseJSON(safeData) {
                        //self.delegate?.didUpdateNews(self, news: news)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ newsData: Data) -> NewsModel? {
        let decoder = JSONDecoder()
        do{
            let decodedData = try decoder.decode(NewsResults.self, from: newsData)
            
            let articles = decodedData.articles
            //print(articles)
            
            let author = articles[0].author ?? ""
            let title = articles[0].title ?? ""
            let description = articles[0].description ?? ""
            let url = articles[0].url ?? ""
            let urlToImage = articles[0].urlToImage ?? ""
            
            let news = NewsModel(author: author, title: title, description: description, url: url, urlToImage: urlToImage)
            newsArray.append(news)
            //print(news)
            return news
            
        } catch {
            //delegate?.didFailWithError(error: error)
            return nil
        }
    }
}


