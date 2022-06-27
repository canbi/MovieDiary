//
//  SearchResult.swift
//  MovieDiary
//
//  Created by Can Bi on 27.06.2022.
//

import Foundation

// MARK: - Welcome
struct SearchResult: Codable {
    let search: [Search]?
    let totalResults: String?
    let response: String
    let error: String?

    enum CodingKeys: String, CodingKey {
        case search = "Search"
        case totalResults
        case response = "Response"
        case error = "Error"
    }
}

// MARK: - Search
struct Search: Codable {
    let title, year, imdbID: String
    let type: SearchType
    let poster: String

    enum CodingKeys: String, CodingKey {
        case title = "Title"
        case year = "Year"
        case imdbID
        case type = "Type"
        case poster = "Poster"
    }
    
    static var previewData: Search {
        return .init(title: "The Social Network",
                     year: "2010",
                     imdbID: "tt1285016",
                     type: .movie,
                     poster: "https://m.media-amazon.com/images/M/MV5BOGUyZDUxZjEtMmIzMC00MzlmLTg4MGItZWJmMzBhZjE0Mjc1XkEyXkFqcGdeQXVyMTMxODk2OTU@._V1_SX300.jpg")
    }
}
