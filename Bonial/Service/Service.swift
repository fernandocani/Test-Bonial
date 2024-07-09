//
//  Service.swift
//  Bonial
//
//  Created by Fernando Cani on 08/07/2024.
//

import Foundation

/// A protocol that defines the necessary methods for fetching news.
protocol Service {
    
    /// Fetches news articles for a given page.
    /// - Parameter page: The page number to fetch.
    /// - Returns: An array of `News` objects.
    /// - Throws: `NewsError` if the fetching fails.
    func getNews(page: Int) async throws -> [News]
    
}
