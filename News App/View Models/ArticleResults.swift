//
//  NewsModel.swift
//  News App
//
//  Created by Abdullah Nana on 2021/07/01.
//

import Foundation

struct ArticleResults {
    let news: Article
    
    var author: String {
        return news.author ?? "Unknown"
    }
    
    var title: String {
        return news.title ?? ""
    }
    
    var description: String {
        return news.description ?? ""
    }
    
    var url: String {
        return news.url ?? ""
    }
    
    var urlToImage: String {
        return news.urlToImage ?? ""
    }
}
