//
//  Endpoint.swift
//  MarsRoverPhotos
//
//  Created by Can Bi on 22.06.2022.
//

import Foundation

struct Endpoint {
    let path: String
    var queryItems: [URLQueryItem]
    
    static let apiKey = "ae9335fd"
    
    var url: URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "omdbapi.com"
        components.path = path
        components.queryItems = queryItems
        
        return components.url
    }
}

// MARK: - Functions
extension Endpoint {
    static func search(for searchText: String,
                       type: SearchType?,
                       year: Int?,
                       page: Int) -> Endpoint {
        Endpoint(path: "", queryItems: [URLQueryItem(name: "s", value: searchText),
                                        URLQueryItem(name: "apikey", value: apiKey),
                                        URLQueryItem(name: "type", value: type?.rawValue),
                                        URLQueryItem(name: "y", value: year != nil ? String(year!) : nil),
                                        URLQueryItem(name: "page", value: String(page))])
    }
    
    static func getMovie(for imdbId: String,
                         plot: String) -> Endpoint {
        Endpoint(path: "", queryItems: [URLQueryItem(name: "i", value: imdbId),
                                        URLQueryItem(name: "apikey", value: apiKey),
                                        URLQueryItem(name: "plot", value: plot)])
    }
}
