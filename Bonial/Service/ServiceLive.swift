//
//  ServiceLive.swift
//  Bonial
//
//  Created by Fernando Cani on 08/07/2024.
//

import Foundation

struct ServiceLive: Service {
    
    private let baseURL: String = "https://newsapi.org/v2/"
    private let apiKey: String = "243920dbdf154e078e51ea1cbddc7d22"
    
    private init() { }
    
    static let shared = ServiceLive()
    
}

extension ServiceLive {
    
    func getNews(page: Int) async throws -> [News] {
        let queryItems: [URLQueryItem] = [
            URLQueryItem(name: "pageSize", value: page == 1 ? "21" : "7"),
            URLQueryItem(name: "page", value: String(page)),
            URLQueryItem(name: "apiKey", value: self.apiKey)
        ]
        let urlString = self.baseURL + "top-headlines"
        let data = try await self.get(urlString: urlString, queryItems: queryItems)
        let response = try Utilities.jsonDecoder.decode(NewsResponse.self, from: data)
        return response.articles
    }
    
}

extension ServiceLive {
    
    private func get(urlString: String,
                     parameters: [String: String]? = nil,
                     queryItems: [URLQueryItem]? = nil) async throws -> Data {
        guard var components = URLComponents(string: urlString) else {
            throw NewsError.invalidURL
        }
        
        components.queryItems = queryItems
        
        guard let url = components.url else {
            throw NewsError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        if let parameters {
            for (key, value) in parameters {
                request.setValue(value, forHTTPHeaderField: key)
            }
        }
        
        let session = URLSession.shared
        session.configuration.waitsForConnectivity = true
        
        do {
            let (data, response) = try await session.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NewsError.generic("DEBUG: invalid HTTPURLResponse")
            }
            guard httpResponse.statusCode == 200 else {
                throw self.handleHTTPError(statusCode: httpResponse.statusCode, data: data)
            }
            return data
        } catch {
            throw error
        }
    }
    
    private func handleHTTPError(statusCode: Int, data: Data) -> Error {
        switch statusCode {
        case 400:
            return NewsError.badRequest
        case 401:
            return NewsError.unauthorized
        case 429:
            return NewsError.rateLimited
        case 500:
            return NewsError.serverError
        default:
            do {
                let newsError = try Utilities.jsonDecoder.decode(APIError.self, from: data)
                guard let message = newsError.message else {
                    return NewsError.generic("DEBUG: \(statusCode)")
                }
                return NewsError.generic(message)
            } catch {
                return NewsError.generic("DEBUG: \(statusCode)")
            }
        }
    }
    
}
