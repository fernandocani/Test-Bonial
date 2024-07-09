//
//  NewsError.swift
//  Bonial
//
//  Created by Fernando Cani on 08/07/2024.
//

import Foundation

enum NewsError: LocalizedError {
    
    case invalidURL
    case generic(String)
    case badRequest
    case unauthorized
    case rateLimited
    case serverError
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "The URL provided was invalid."
        case .generic(let string):
            return "An error occurred: \(string)"
        case .badRequest:
            return "The request was unacceptable, often due to a missing or misconfigured parameter."
        case .unauthorized:
            return "Your API key was missing from the request, or wasn't correct."
        case .rateLimited:
            return "You have made too many requests recently. Developer accounts are limited to 100 requests over a 24-hour period (50 requests available every 12 hours). Please upgrade to a paid plan if you need more requests."
        case .serverError:
            return "Something went wrong on our side."
        }
    }
    
    var recoverySuggestion: String? {
        switch self {
        case .invalidURL:
            return "Please check the URL and try again."
        case .generic:
            return "Please try again later."
        case .badRequest:
            return "Please check the request parameters and try again."
        case .unauthorized:
            return "Please verify your API key and try again."
        case .rateLimited:
            return "Please wait and try again later."
        case .serverError:
            return "Please try again later."
        }
    }
}
