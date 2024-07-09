//
//  APIError.swift
//  Bonial
//
//  Created by Fernando Cani on 08/07/2024.
//

import Foundation

struct APIError: Decodable {
    let status: String?
    let message: String?
    let code: String?
}
