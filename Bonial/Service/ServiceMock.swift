//
//  ServiceMock.swift
//  Bonial
//
//  Created by Fernando Cani on 08/07/2024.
//

import Foundation

struct ServiceMock: Service {
    
    var stubbedNews: [News] = []
    var shouldThrowError: Bool = false
    
    private init() { }
    
    static var shared = ServiceMock()
    
}

extension ServiceMock {
    
    func getNews(page: Int) async throws -> [News] {
        if self.shouldThrowError {
            throw NewsError.generic("Simulated error")
        }
        if !self.stubbedNews.isEmpty {
            return self.stubbedNews
        }
        
        let jsonFilename: String = switch page {
        case 1: "initialLoad"
        case 2: "pagination2"
        case 3: "pagination3"
        default: ""
        }
        guard !jsonFilename.isEmpty else {
            return []
        }
        guard let url = Bundle.main.url(forResource: jsonFilename, withExtension: "json") else {
            throw NewsError.invalidURL
        }
        do {
            let response: NewsResponse = try Utilities.loadStub(url: url)
            return response.articles
        } catch {
            throw NewsError.generic("Failed to load stub data: \(error.localizedDescription)")
        }
    }
    
}
