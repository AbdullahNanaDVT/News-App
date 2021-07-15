//
//  NewsListViewModel.swift
//  News App
//
//  Created by Abdullah Nana on 2021/07/14.
//
import Foundation

class NewsListViewModel {
    var newsArray = [NewsViewModel]()
    internal var countryCode = NSLocale.current.regionCode?.lowercased()
    
    func loadNewsData(searchString: String = "", countryCode:String = "", completion: @escaping ([NewsViewModel]) -> Void) {
        NewsManager.shared.loadNewsData(searchString: searchString, countryCode: countryCode) { (news) in
            guard let news = news else {return}
            let newsVM = news.map(NewsViewModel.init)
            DispatchQueue.main.async {
                self.newsArray = newsVM
                completion(newsVM)
            }
        }
    }
}
