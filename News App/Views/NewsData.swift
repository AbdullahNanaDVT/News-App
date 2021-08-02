//
//  NewsData.swift
//  News App
//
//  Created by Abdullah Nana on 2021/07/01.
//

import Foundation

struct NewsData: Codable {
    let author: String?
    let title: String?
    let description: String?
    let url: String?
    let urlToImage: String?
}

struct NewsResults: Codable {
    let status: String
    let totalResults: Int
    let articles: [NewsData]
}
