//
//  NewsViewModel.swift
//  Bonial
//
//  Created by Fernando Cani on 08/07/2024.
//

import Foundation

/// ViewModel for managing news data.
final class NewsViewModel: NSObject {
    
    private(set) var service: Service
    private(set) var news: [News] = []
    private var currentPage: Int = 1
    
    /// Initializes the ViewModel with a specified service.
    /// - Parameter service: The service to be used for fetching news.
    init(_ service: Service) {
        self.service = service
        super.init()
    }
    
    /// Resets the news data and current page.
    func reset() {
        self.currentPage = 1
        self.news = []
    }
    
    /// Loads more news from the current service.
    /// - Throws: An error if the fetching fails.
    func loadMoreNews() async throws {
        let moreNews = try await self.service.getNews(page: self.currentPage)
        self.news.append(contentsOf: moreNews.filter { $0.title != "[Removed]" })
        self.currentPage += 1
    }
    
    /// Changes the service and resets the news data.
    /// - Parameter service: The new service to be used.
    func changeService(service: Service) {
        self.service = service
        self.reset()
    }
    
}
