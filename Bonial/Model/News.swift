//
//  News.swift
//  Bonial
//
//  Created by Fernando Cani on 08/07/2024.
//

import Foundation
    
struct NewsResponse: Decodable {
    let status: String
    let articles: [News]
}

struct News: Decodable {
    let author: String?
    let title: String?
    let description: String?
    let url: URL?
    let urlToImage: URL?
    let publishedAt: Date?
    let content: String?
    let source: Source?
}

struct Source: Decodable {
    let id: String?
    let name: String?
}
