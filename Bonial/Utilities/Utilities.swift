//
//  Utilities.swift
//  Bonial
//
//  Created by Fernando Cani on 08/07/2024.
//

import Foundation

struct Utilities {
    
    static let jsonDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        return decoder
    }()
    
    static func loadStub<T: Decodable>(url: URL) -> T {
        let data = try! Data(contentsOf: url)
        do {
            let d = try Utilities.jsonDecoder.decode(T.self, from: data)
            return d
        } catch let error as DecodingError {
            print(error.localizedDescription)
            fatalError()
        } catch {
            fatalError()
        }
    }
    
}
